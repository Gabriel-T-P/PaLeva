class CreatePromotionOrders < ActiveRecord::Migration[7.2]
  def change
    create_table :promotion_orders do |t|
      t.references :promotion, null: false, foreign_key: true
      t.references :order, null: false, foreign_key: true

      t.timestamps
    end
  end
end
