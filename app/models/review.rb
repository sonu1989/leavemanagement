class Review < ApplicationRecord
  belongs_to :employee, class_name: "User", foreign_key: :user_id
  belongs_to :reviewer, class_name: "User", foreign_key: :reviewer_id

  validates_presence_of :feedback, :reviewer_id, :rating
  
  RATINGS = {'Good': 10, 'Above Average': 7.5, 'Average': 5, 'Below Average': 2.5}
  
  after_create :notify_employee

  private
    def notify_employee
      UserMailer.send_feedback_notification(self).deliver_now
    end
end
