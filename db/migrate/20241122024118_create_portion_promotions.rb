class CreatePortionPromotions < ActiveRecord::Migration[7.2]
  def change
    create_table :portion_promotions do |t|
      t.references :portion, null: false, foreign_key: true
      t.references :promotion, null: false, foreign_key: true

      t.timestamps
    end
  end
end
