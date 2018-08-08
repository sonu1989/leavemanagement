class AddColumnApplyLeavesToLeaves < ActiveRecord::Migration[5.2]
  def change
    add_column :leaves, :leave_type, :text
  end
end
