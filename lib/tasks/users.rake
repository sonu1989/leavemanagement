namespace :users do
  desc "TODO"
  
  task increment_employee_id: :environment do  
    u = User.unscoped.order(:id)
    u.each_with_index do |user,index|
      user.update_attributes(employee_id: index+1)
    end 
  end

  task add_leave_balance: :environment do  
    if Time.now.day == 1
      users = User.all
      month = Time.now.month
      number_of_day = ((month % 3) == 0 ? 2 : 1)
      users.each do |user|
        last_balance = user.balances.order('created_at DESC').first
        if last_balance.present?
          last_balance.update(main_balance: 0) if last_balance.main_balance < 0
          main_balance = last_balance.main_balance + number_of_day
        else
          main_balance = number_of_day
        end
        user.balances.create(main_balance: main_balance, balance_added: number_of_day)
      end
    end 
  end
   
  task one_day_before_send_email: :environment do
    admin = User.find_by_role('admin')
    leaves = Leave.where("start_date == ? AND status == ?", Date.tomorrow, 'pending')
    leaves.each do |leave|
      UserMailer.with(leave: leave).manager_remainder_email.deliver_now if leave.user.manager.present?
      UserMailer.with(leave: leave, admin: admin).admin_remainder_email.deliver_now 
    end
  end

  task on_end_date_send_mail: :environment do
    admin = User.find_by_role('admin')
    leaves = Leave.where("end_date == ? AND status == ?", Date.today, 'pending')
    leaves.each do |leave|
      UserMailer.with(leave: leave).manager_remainder_email_on_end_date.deliver_now if leave.user.manager.present?
      UserMailer.with(leave: leave, admin: admin).admin_remainder_email_on_end_date.deliver_now
      UserMailer.with(leave: leave).user_remainder_email_on_end_date.deliver_now
      leave.sent_notification_count =  leave.sent_notification_count + 1
      leave.save
    end
  end

  task update_leave_unapproved: :environment do
    admin = User.find_by_role('admin')
    leaves = Leave.where(status: 'pending', sent_notification_count: 1)
    leaves.each do |leave|
      if leave.end_date <= Date.today
        leave.update(status: 'Unapproved')
      end
      UserMailer.with(leave: leave).user_remainder_email_on_end_date.deliver_now
      UserMailer.with(leave: leave).manager_remainder_email_on_end_date.deliver_now if leave.user.manager.present?
      UserMailer.with(leave: leave, admin: admin).admin_remainder_email_on_end_date.deliver_now 
    end
  end
end

