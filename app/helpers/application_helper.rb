module ApplicationHelper
  def employee_options
    User.where.not('role =? OR id=?', 'admin', current_user.id).map {|u| [u.id, u.user_name.to_s.titleize]}
  end

  def assign_managers
    User.managers.all.map {|u| [u.id, u.user_name]}
  end  

  def employees_leave
    User.find(current_user.id).employees.all.map {|u| [u.id ,u.user_name]}
  end 

  def leave_type_options
    [['Full Day ', 'Full Day '], ['Half Day', 'Half Day']]
  end

  def choose_month
     [['January ',1], [ 'Febraury',2], ['March',3], ['April',4],['May',5], ['June',6],['July',7],['August',8],['September',9],['October',10],['November',11],['December',12]]
  end

  def leave_already_taken_day
    if params[:team_member] != 'true'
      user = current_user
      leaves = user.leaves.includes(:leave_days)
      @taken_leave_days = leaves.map{|leave| leave.leave_days.map{|ld| ld.date.strftime('%d/%m/%Y') rescue '' }}
      @taken_leave_days.flatten
    end
  end

  def holiday_dates
    Holiday.all
  end

  def is_holiday(date)
    @holidays ||= holiday_dates
    holiday = @holidays.select{|h| h if h.date.strftime('%d/%m/%Y') == date }.first
    holiday
  end

  def month_holidays(date)
    start_date = date.at_beginning_of_month
    end_date = date.at_end_of_month
    Holiday.where(date: (start_date)..(end_date))
  end  
end
