class AddPlacedByIdIntoLeaves < ActiveRecord::Migration[5.2]
  def change
    add_column :leaves, :placed_by_id, :integer
  end
end
