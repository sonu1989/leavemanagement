class CreateLeaveDays < ActiveRecord::Migration[5.2]
  def change
    create_table :leave_days do |t|
      t.integer :leave_id
      t.date :date
      t.string :leave_type
      t.timestamps
    end
  end
end
