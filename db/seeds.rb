

today = Date.today
student_ids = Array.new
subscription_ids = Array.new
rand_schedules = Array.new

#create subscriptions
subscription_ids.push(Subscription.create(name: '1 Lesson per day', max_daily: 1).id)
subscription_ids.push(Subscription.create(name: '2 Lessons per day', max_daily: 2).id)
subscription_ids.push(Subscription.create(name: '3 Lessons per day', max_daily: 3).id)

#create teachers, schedules and students

50.times do |_|

  teacher = Teacher.create(name: Faker::Name.name, gender: [0,1].sample, nationality: Faker::Address.country_code)
  schedule_ids = Array.new
  #create random amount of schedules for teacher
  schedule_count = rand(5...15)
  start_time = DateTime.new(today.year, today.month, today.day, rand(0...23), [0,30].sample, 0)
  schedule_count.times do||
    schedule = Schedule.new(
        :teacher    => teacher,
        :start_time => start_time,
        :end_time   => start_time + (30/1440.0), #add 30 minutes to start time
        :schedule_status     => 0 #vacant schedule
    )
    schedule.save!
    schedule_ids.push(schedule.id)
    start_time = start_time +([30,60,90,120,150].sample/1440.0)
  end
  #get 3 random schedules to be set as 'taken' later
  rand_schedules.push(schedule_ids.sample(3))

  password = Faker::Internet.password(10,15)
  student = Student.new(
      :email                 => Faker::Internet.safe_email(Faker::Name.first_name),
      :password              => password,
      :password_confirmation => password,
      :name                  => Faker::Name.name
  )

  #catch email duplicate error in case faker generates same emails
  begin
    student.save!
    student_ids.push(student.id)
  rescue
    p 'duplicate email... probably'
  end

end

#create lessons from random schedules
rand_schedules.each do |schedule_id|
  lesson = Lesson.new(
      :schedule_id  => schedule_id,
      :student_id => student_ids.sample,
      :subscription_id => subscription_ids.sample,
      :lesson_status => 1,
      :lesson_date => Date.today #not important for sample lessons
  )
  lesson.save!
end

#update all taken schedules' status to 1 meaning taken already
taken_schedules = Schedule.where(:id => rand_schedules)
taken_schedules.update_all(:schedule_status => 1)