class CreatePortionOrders < ActiveRecord::Migration[7.2]
  def change
    create_table :portion_orders do |t|
      t.references :portion, null: false, foreign_key: true
      t.references :order, null: false, foreign_key: true
      t.integer :quantity
      t.string :observation

      t.timestamps
    end
  end
end
