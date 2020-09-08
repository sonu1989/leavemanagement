class RemoveStatusFromReviews < ActiveRecord::Migration[5.2]
  def change
  	remove_column :reviews, :status, :integer
  end
end
