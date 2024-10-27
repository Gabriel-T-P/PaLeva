class AddAlcoholicToItems < ActiveRecord::Migration[7.2]
  def change
    add_column :items, :alcoholic, :boolean
  end
end
