class RenameColumnLeaveTypeToDays < ActiveRecord::Migration[5.2]
  def change
    rename_column :leaves, :leave_type, :days
  end
end
