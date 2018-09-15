class UserMailer < ApplicationMailer

  def user_leave_email
    @leave = params[:leave]
    @user = @leave.user
    attachments.inline['logo.png'] = File.read("#{Rails.root}/app/assets/images/logo.png")
    attachments.inline['logo2.png'] = File.read("#{Rails.root}/app/assets/images/logo2.png")
    mail(to: @user.email, subject: 'Your leave has been applied')
  end

  def manager_leave_email
    attachments.inline['logo.png'] = File.read("#{Rails.root}/app/assets/images/logo.png")
    attachments.inline['logo2.png'] = File.read("#{Rails.root}/app/assets/images/logo2.png")
    @leave = params[:leave]
    @manager = @leave.user.manager
    @user = @leave.user
    mail(to: @manager.email, subject: "#{@leave.user.user_name} is applied leave for #{@leave.leave_taken_days} days")
  end 
  def admin_leave_email
    @leave = params[:leave]
    @admin = params[:admin]
    attachments.inline['logo.png'] = File.read("#{Rails.root}/app/assets/images/logo.png")
    attachments.inline['logo2.png'] = File.read("#{Rails.root}/app/assets/images/logo2.png")
    mail(to: @admin.email ,subject: "#{@leave.user.user_name} is applied leave for #{@leave.leave_taken_days} days")
  end  
end
