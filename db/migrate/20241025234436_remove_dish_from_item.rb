class RemoveDishFromItem < ActiveRecord::Migration[7.2]
  def change
    remove_column :items, :dish, :boolean
  end
end
