class AddColumnEmployeeIdToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :employee_id, :integer, auto_increment: true
  end
end
