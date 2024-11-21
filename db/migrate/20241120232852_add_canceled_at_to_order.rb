class AddCanceledAtToOrder < ActiveRecord::Migration[7.2]
  def change
    add_column :orders, :canceled_at, :datetime
    add_column :orders, :waiting_cook_confirmation_at, :datetime
    add_column :orders, :cooking_at, :datetime
    add_column :orders, :ready_at, :datetime
    add_column :orders, :delivered_at, :datetime
  end
end
