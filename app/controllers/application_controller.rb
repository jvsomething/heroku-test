class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception


  def after_sign_out_path_for(resource_or_scope)
    new_student_session_path
  end

  def after_sign_in_path_for(resource)
    if current_student.subscription_id.nil?
      flash[:notice] = 'You haven\'t subscribed to a plan yet. Please choose a subscription.'
      subscriptions_path
    else
      lessons_path
    end
  end

end
