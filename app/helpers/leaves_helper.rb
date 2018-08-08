module LeavesHelper
  
  def is_employee?
    current_user.role == 'employee'
  end
  
  def is_manager?
    current_user.role == 'manager'
  end
  
  def is_admin?
     current_user.role == 'admin'
  end
     
  def truncate_description(str)
    str.truncate(60)
  end

end
