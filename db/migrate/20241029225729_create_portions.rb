class CreatePortions < ActiveRecord::Migration[7.2]
  def change
    create_table :portions do |t|
      t.string :name, null: false
      t.string :description, null: false
      t.decimal :price, null: false, precision: 10, scale: 2
      t.boolean :active, null: false, default: true
      t.references :item, null: false, foreign_key: true

      t.timestamps
    end
  end
end
