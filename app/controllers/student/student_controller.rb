class Student::StudentController < ApplicationController

  before_action :authenticate_student!

  def subscriptions
    @subscriptions = Subscription.all
  end

  def teachers
    page_num = 1
    if params[:page].present?
      page_num = Integer(params[:page]) rescue 1
    end

    keyword = params[:name]

    @teachers = Teacher.page(page_num).per(8)

    @teachers = @teachers.where('lower(name) LIKE :search', search: "%#{keyword.downcase}%") if keyword.to_s.strip.length > 0
    if params[:gender].present?
      @teachers = @teachers.where('gender IN (?)',params[:gender])
    end

    if params[:nationality].present? && params[:nationality][0].to_s.strip.length > 0
      @teachers = @teachers.where('nationality IN (?)',params[:nationality])
    end

    if params[:availability].present? && params[:availability].to_i == 1
      from_date = Date.strptime(params[:'from'],'%B %d, %Y') if params[:'from'].present?
      to_date = Date.strptime(params[:'to'],'%B %d, %Y') if params[:'to'].present?
      from_date = from_date || Date.today
      to_date = to_date || Date.today
      @teachers = @teachers.joins('inner join schedules on teachers.id = schedules.teacher_id').where('date(start_time) between ? and ? and schedule_status = 0',from_date,to_date).group('teachers.id')
    end

  end

  def get_teacher_schedule
    teacher_id = params[:teacher_id]

    @teacher = Teacher.where(:id => teacher_id).first
    if @teacher.nil?
      redirect_to teachers_path, :notice => 'Teacher doesn\'t exist' and return
    end

    raw_schedules = Schedule.where('teacher_id = ? and start_time > ? and start_time < ?', teacher_id.to_i,DateTime.now,(DateTime.now + 3.day))
    @hashed_schedules = Hash.new
    raw_schedules.each do |schedule|
      @hashed_schedules[schedule.start_time.strftime('%Y%m%d%H%M')] = schedule
    end
  end

  def lessons
    @lessons = Lesson.joins(schedule: [:teacher]).where('student_id = ? and start_time > ? and lesson_status = 1',current_student.id, DateTime.now).order('start_time ASC')
  end

  def book_lesson

    #validate that student has an active subscription
    subscription = Subscription.where(:id => current_student.subscription_id).first
    if subscription.nil?
      redirect_to subscriptions_path, :notice => 'You don\'t have an active subscription.' and return
    end

    #validate that schedule is available
    schedule_id = params[:id].to_i
    schedule = Schedule.where(:id => schedule_id).first
    if schedule.nil? || schedule.schedule_status == 1
      redirect_to teachers_path, :notice => 'The schedule is no longer available' and return
    end

    #validate max subscription
    active_lesson_count = Lesson.joins(:schedule).where('student_id = ? and lesson_date = ? and lesson_status = 1',current_student.id,schedule.start_time.to_date).count
    if active_lesson_count >= subscription.max_daily
      redirect_to teachers_path, :notice => 'Sorry you\'ve maxed out already on lessons for the day' and return
    end


    Schedule.transaction do

      schedule.update(:schedule_status => 1)

      lesson = Lesson.new(
          :schedule_id  => schedule_id,
          :student_id => current_student.id,
          :subscription_id => current_student.subscription_id,
          :lesson_status => 1,
          :lesson_date => schedule.start_time
      )
      unless lesson.save!
        raise ActiveRecord::Rollback
      end
    end

    redirect_to lessons_path, :notice => 'Successfully booked lesson'
  end

  def cancel_lesson
    lesson_id = params[:id].to_i
    lesson = Lesson.where(:id => lesson_id).first

    #validate that lesson exists and still active
    if lesson.nil? || lesson.lesson_status == 0
      redirect_to lessons_path, :notice => 'Lesson doesn\'t exist anymore' and return
    end

    schedule = Schedule.where(:id => lesson.schedule_id).first
    #validate cancellation of old lessons
    if schedule.nil? || schedule.start_time <= DateTime.now
      redirect_to lessons_path, :notice => 'Lesson doesn\'t exist anymore' and return
    end

    #open the teacher's schedule and set lesson inactive
    Schedule.transaction do
      schedule.update(:schedule_status => 0)
      lesson.update(:lesson_status => 0)
    end

    redirect_to lessons_path, :notice => 'Successfully Cancelled Lesson'
  end

  def subscribe
    student = Student.where(:id => current_student.id).first
    student.update(:subscription_id => params[:id].to_i)
    current_student.subscription_id = params[:id].to_i
    redirect_to subscriptions_path, :notice => 'Successfully Subscribed to plan'
  end

  private
  def student_authorized?
    unless student_signed_in?
      flash[:danger] = 'You are not authorized to view that page.'
      redirect_to new_student_registration_path
    end
  end

end