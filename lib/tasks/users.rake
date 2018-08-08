namespace :users do
  desc "TODO"
  
  task increment_employee_id: :environment do  
    u = User.unscoped.order(:id)
    u.each_with_index do |user,index|
      user.update_attributes(employee_id: index+1)
    end 
  end

  task add_leave_balance: :environment do  
    users = User.all
    month = Time.now.month
    number_of_day = ((month % 3) == 0 ? 2 : 1)
    users.each do |user|
      last_balance = user.balances.order('created_at DESC').first
      if last_balance.present?
        main_balance = last_balance.main_balance + number_of_day
      else
        main_balance = number_of_day
      end
      user.balances.create(main_balance: main_balance, balance_added: number_of_day)
    end 
  end
   
end
