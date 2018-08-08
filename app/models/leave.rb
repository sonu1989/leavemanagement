class Leave < ActiveRecord::Base

  validates_presence_of :description, :user_id   
  validate :date_range
  belongs_to :user
  default_scope {where(deleted: false)}
  serialize :days, Hash
  attr_accessor :leave_type
  has_many :leave_days, dependent: :destroy

  FULL_DAY = 'Full Day '
  
  def send_notifications(current_user)
    @admin = User.find_by_role('admin')
    if current_user.is_employee?
      UserMailer.with(leave: self, placed_by: current_user.user_name).user_leave_email.deliver_now
      UserMailer.with(leave: self).manager_leave_email.deliver_now if self.user.manager.present?
      UserMailer.with(leave: self,admin: @admin).admin_leave_email.deliver_now
    elsif current_user.is_admin?
      if self.user.role == 'manager'
        UserMailer.with(leave: self, placed_by: current_user.user_name).user_leave_email.deliver_now      
        UserMailer.with(leave: self,admin: @admin).admin_leave_email.deliver_now
      else
        UserMailer.with(leave: self, placed_by: current_user.user_name).user_leave_email.deliver_now
        UserMailer.with(leave: self).manager_leave_email.deliver_now if self.user.manager.present?
        UserMailer.with(leave: self,admin: @admin).admin_leave_email.deliver_now
      end  
    else
      if current_user.id == self.user_id 
        UserMailer.with(leave: self, placed_by: current_user.user_name).user_leave_email.deliver_now
        UserMailer.with(leave: self,admin: @admin).admin_leave_email.deliver_now
      else
        UserMailer.with(leave: self, placed_by: current_user.user_name).user_leave_email.deliver_now
        UserMailer.with(leave: self).manager_leave_email.deliver_now if self.user.manager.present?
        UserMailer.with(leave: self,admin: @admin).admin_leave_email.deliver_now
      end   
    end    
  end

  def assign_start_end_date
    all_leaves = self.leave_days.order(:date)
    self.update_attributes(start_date: all_leaves.first.try(:date), end_date: all_leaves.last.try(:date))
  end

  # Deduct leave balance
  def deduct_leave_balance
    full_days_count = self.leave_days.where('lower(leave_type) =?', FULL_DAY.downcase).count
    half_days_count = self.leave_days.count - full_days_count

    total_days_count = full_days_count + (half_days_count.to_f/2)
    user = self.user
    last_balance = user.balances.order('created_at DESC').first
    if last_balance.present?
      main_balance = last_balance.main_balance - total_days_count
    else
      main_balance = 0 - total_days_count
    end
    user.balances.create(main_balance: main_balance, balance_deducted: total_days_count)
  end      

  private
    def date_range
      if self.start_date.present? && self.end_date.present?
      	if ((self.start_date)..(self.end_date)).select {|d| (1..5).include?(d.wday) }.size > 30
          errors.add(:date_range, "You can't sumbit leave more than 30 days.")
        end
      end
    end
    
end
