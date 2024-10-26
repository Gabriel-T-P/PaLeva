class CreateItems < ActiveRecord::Migration[7.2]
  def change
    create_table :items do |t|
      t.string :name,               null: false
      t.string :description,        null: false
      t.integer :calories,          null: false
      t.references :establishment,  null: false, foreign_key: true
      t.boolean :dish

      t.timestamps
    end
  end
end
