class AddItemTypeToItem < ActiveRecord::Migration[7.2]
  def change
    add_column :items, :item_type, :integer, null: false
  end
end
