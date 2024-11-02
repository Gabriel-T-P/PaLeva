class CreatePriceHistories < ActiveRecord::Migration[7.2]
  def change
    create_table :price_histories do |t|
      t.decimal :price,       null: false, precision: 10, scale: 2
      t.datetime :added_at,   null: false
      t.datetime :ended_at,   null: false
      t.boolean :current,     null: false, default: true
      t.references :portion,  null: false, foreign_key: true

      t.timestamps
    end
  end
end
