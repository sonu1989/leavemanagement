class AddJoiningDateToUser < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :joining_date, :date
  end
end
