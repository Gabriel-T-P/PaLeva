class CreateEstablishments < ActiveRecord::Migration[7.2]
  def change
    create_table :establishments do |t|
      t.string :trade_name,     null: false
      t.string :corporate_name, null: false
      t.string :cnpj,           null: false
      t.string :full_address,   null: false
      t.string :phone_number,   null: false
      t.string :email,          null: false
      t.string :code,           null: false
      t.references :users,      null: false, foreign_key: true

      t.timestamps
    end
  end
end
