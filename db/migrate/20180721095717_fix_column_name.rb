class FixColumnName < ActiveRecord::Migration[5.2]
  def change
    remove_column :users, :user_type
    add_column :users, :role, :integer
  end
end
