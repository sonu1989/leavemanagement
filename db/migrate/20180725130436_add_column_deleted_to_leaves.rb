class AddColumnDeletedToLeaves < ActiveRecord::Migration[5.2]
  def change
    add_column :leaves, :deleted, :boolean, default: false
  end
end
