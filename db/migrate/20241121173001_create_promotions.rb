class CreatePromotions < ActiveRecord::Migration[7.2]
  def change
    create_table :promotions do |t|
      t.string :name,         null: false
      t.decimal :percentage,  null: false, precision: 5, scale: 4
      t.date :start_date,     null: false
      t.date :end_date,       null: false

      t.timestamps
    end
  end
end
