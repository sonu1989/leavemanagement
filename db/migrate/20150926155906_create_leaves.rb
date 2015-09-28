class CreateLeaves < ActiveRecord::Migration
  def change
    create_table :leaves do |t|
      t.date :start_date
      t.date :end_date
      t.text :description
      t.string :status, default: "pending"
      t.integer :user_id

      t.timestamps
    end
  end
end
