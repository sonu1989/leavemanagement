class AddCountToLeave < ActiveRecord::Migration[5.2]
  def change
    add_column :leaves, :sent_notification_count, :integer, :default => 0
  end
end
