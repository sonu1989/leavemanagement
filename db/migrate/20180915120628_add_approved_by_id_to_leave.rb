class AddApprovedByIdToLeave < ActiveRecord::Migration[5.2]
  def change
    add_column :leaves, :status_updated_by_id, :integer
  end
end
