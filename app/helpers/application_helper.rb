module ApplicationHelper
  
  def is_employee?
    current_user.user_type == 'employee'
  end
  
  def is_manager?
    current_user.user_type == 'manager'
  end
  
  def truncate_description(str)
    str.truncate(60)
  end
end
