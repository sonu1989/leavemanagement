class CreateReviewRequests < ActiveRecord::Migration[5.2]
  def change
    create_table :review_requests do |t|
      t.integer :user_id
      t.integer :reviewer_id
      t.integer :status

      t.timestamps
    end
  end
end
