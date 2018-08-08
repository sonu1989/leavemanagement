class CreateHolidays < ActiveRecord::Migration[5.2]
  def change
    create_table :holidays do |t|
      t.date :date
      t.string :occasion

      t.timestamps
    end
  end
end
