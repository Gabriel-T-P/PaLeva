class ChangeColumnDefaultMenu < ActiveRecord::Migration[7.2]
  def change
    change_column_default :menus, :establishment_id, nil
  end
end
