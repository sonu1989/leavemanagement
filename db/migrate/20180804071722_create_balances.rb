class CreateBalances < ActiveRecord::Migration[5.2]
  def change
    create_table :balances do |t|
      t.integer :user_id
      t.decimal :main_balance
      t.decimal :balance_added
      t.decimal :balance_deducted
      t.timestamps
    end
  end
end
