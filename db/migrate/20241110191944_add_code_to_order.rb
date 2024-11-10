class AddCodeToOrder < ActiveRecord::Migration[7.2]
  def change
    add_column :orders, :code, :string
  end
end
