class CreateLeaves < ActiveRecord::Migration
  def change
    create_table :leaves do |t|
      t.integer :user_id
      t.date :start_date
      t.date :end_date
      t.text :description
      t.string :status, default: "pending"
      t.string :reason
      t.timestamps
    end
  end
end
