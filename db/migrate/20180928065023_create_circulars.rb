class CreateCirculars < ActiveRecord::Migration[5.2]
  def change
    create_table :circulars do |t|
      t.text :note
      t.date :published_at
      t.boolean :published, default: false
      t.timestamps
    end
  end
end
