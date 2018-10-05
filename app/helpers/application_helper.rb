module ApplicationHelper
  def employee_options
    User.where.not(role: 'admin').where.not(id: current_user.id).map {|u| [u.id, u.user_name.to_s.titleize]}
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
      leaves = user.leaves.where.not(status: 'cancelled').includes(:leave_days)
      @taken_leave_days = leaves.map{|leave| leave.leave_days.map{|ld| [{date: ld.date.strftime('%d/%m/%Y'), type: ld.leave_type}] rescue '' }}
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

  def alternate_saturday
    start_date = '08/09/2018'.to_date
    end_date = Date.today + 1.year
    my_days = [6]
    all_saturdays = (start_date..end_date).to_a.select {|k| my_days.include?(k.wday)}
    alt_saturdays = []
    all_saturdays.each_with_index do |day, index|
      alt_saturdays << day.strftime('%d/%m/%Y') if (index % 2 == 0)
    end
    alt_saturdays
  end

  def taken_or_applied(date)
    leave_already_taken_day.present? ? leave_already_taken_day.select{|leave_day| leave_day if leave_day[:date] == date} : []
  end

  def leave_days_with_type(leave)
    leave_days = [] 
    leave.leave_days.each do|leave_day| 
      leave_days << "#{leave_day.date.strftime('%d/%m/%Y')}(#{leave_day.leave_type})" 
    end
    leave_days.join(' ,')
  end

  def circular_note(circulars)
    (circulars rescue'').to_sentence
  end
end
