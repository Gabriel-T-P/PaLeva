class AddEstablishmentToMenu < ActiveRecord::Migration[7.2]
  def change
    add_reference :menus, :establishment, null: false, foreign_key: true, default: 1
  end
end
