class Leave < ActiveRecord::Base

  validates_presence_of :start_date, :end_date, :description
  
  validate :date_range

  belongs_to :user

  private
    def date_range
      if self.start_date.present? && self.end_date.present?
      	if ((self.start_date)..(self.end_date)).select {|d| (1..5).include?(d.wday) }.size > 30
          errors.add(:date_range, "You can't sumbit leave more than 30 days.")
        end
      end
    end
end
