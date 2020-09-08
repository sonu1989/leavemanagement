class ReviewRequest < ApplicationRecord
  enum status: [:pending, :complete]

  belongs_to :employee, class_name: 'User', foreign_key: :user_id
  belongs_to :reviewer, class_name: 'User', foreign_key: :reviewer_id

  after_create :send_review_request

  scope :pending, -> { where(status: 'pending') }



  private 
    def send_review_request
      UserMailer.send_review_requests_notification(self).deliver_now
    end
end
