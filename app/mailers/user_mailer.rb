class UserMailer < ApplicationMailer


  def user_leave_email
    @leave = params[:leave] 
    mail(to: @leave.user.email, subject: 'Welcome to My Awesome Site')
  end

  def manager_leave_email
    @leave = params[:leave]
    mail(to: @leave.user.manager.email, subject: 'Welcome to My Awesome Site')
  end 
  def admin_leave_email
    @leave = params[:leave]
    @admin = params[:admin]
    mail(to: @admin.email ,subject: 'Welcome to My Awesome Site')
  end  
end
