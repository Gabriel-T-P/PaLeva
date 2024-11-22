class AddTotalValueToOrder < ActiveRecord::Migration[7.2]
  def change
    add_column :orders, :total_value, :decimal
    add_column :orders, :final_value, :decimal
  end
end
