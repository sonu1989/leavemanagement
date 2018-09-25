class UserMailer < ApplicationMailer

  def user_leave_email
    @leave = params[:leave]
    @user = @leave.user
    @action = params[:action]
    attachments.inline['logo.png'] = File.read("#{Rails.root}/app/assets/images/logo.png")
    attachments.inline['logo2.png'] = File.read("#{Rails.root}/app/assets/images/logo2.png")
    if @action.eql?("create")
      mail(to: @user.email, subject: 'Your leave has been applied')
    else
      mail(to: @user.email, subject: 'Your leave status has been updated')
    end
  end

  def manager_leave_email
    attachments.inline['logo.png'] = File.read("#{Rails.root}/app/assets/images/logo.png")
    attachments.inline['logo2.png'] = File.read("#{Rails.root}/app/assets/images/logo2.png")
    @leave = params[:leave]
    @manager = @leave.user.manager
    @user = @leave.user
    @action = params[:action]
    if @action.eql?("create")   
      mail(to: @manager.email, subject: "#{@leave.user.user_name} is applied leave for #{@leave.leave_taken_days} days")
    else
      mail(to: @manager.email, subject: "Leave status for #{@leave.user.user_name} has been updated successfully.")
    end 
  end
  def admin_leave_email
    @leave = params[:leave]
    @admin = params[:admin]
    @action = params[:action]
    attachments.inline['logo.png'] = File.read("#{Rails.root}/app/assets/images/logo.png")
    attachments.inline['logo2.png'] = File.read("#{Rails.root}/app/assets/images/logo2.png")
    if @action.eql?("create")   
      mail(to: @admin.email ,subject: "#{@leave.user.user_name} is applied leave for #{@leave.leave_taken_days} days")
    else
       mail(to: @admin.email ,subject: "Leave status for #{@leave.user.user_name} has been updated successfully.")
    end
  end 

  def manager_remainder_email
    attachments.inline['logo.png'] = File.read("#{Rails.root}/app/assets/images/logo.png")
    attachments.inline['logo2.png'] = File.read("#{Rails.root}/app/assets/images/logo2.png")
    @leave = params[:leave]
    @user = @leave.user
    @manager = @leave.user.manager
    mail(to: @manager.email, subject: "Leave action notification")
  end 

  def admin_remainder_email
    attachments.inline['logo.png'] = File.read("#{Rails.root}/app/assets/images/logo.png")
    attachments.inline['logo2.png'] = File.read("#{Rails.root}/app/assets/images/logo2.png")
    @leave = params[:leave]
    @admin = params[:admin]
    mail(to: @admin.email, subject: "Leave action notification")
  end 

  def user_remainder_email_on_end_date
    attachments.inline['logo.png'] = File.read("#{Rails.root}/app/assets/images/logo.png")
    attachments.inline['logo2.png'] = File.read("#{Rails.root}/app/assets/images/logo2.png")
    @leave = params[:leave]
    @user = @leave.user
    mail(to: @user.email, subject: "Leave action notification")
  end

  def admin_remainder_email_on_end_date
    attachments.inline['logo.png'] = File.read("#{Rails.root}/app/assets/images/logo.png")
    attachments.inline['logo2.png'] = File.read("#{Rails.root}/app/assets/images/logo2.png")
    @leave = params[:leave]
    @admin = params[:admin]
    mail(to: @admin.email, subject: "Leave action notification")
  end

  def manager_remainder_email_on_end_date
    attachments.inline['logo.png'] = File.read("#{Rails.root}/app/assets/images/logo.png")
    attachments.inline['logo2.png'] = File.read("#{Rails.root}/app/assets/images/logo2.png")
    @leave = params[:leave]
    @user = @leave.user
    @manager = @leave.user.manager
    mail(to: @manager.email, subject: "Leave action notification")
  end
end
