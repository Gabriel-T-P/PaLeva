class AddStatusToOrder < ActiveRecord::Migration[7.2]
  def change
    add_column :orders, :status, :integer
  end
end
