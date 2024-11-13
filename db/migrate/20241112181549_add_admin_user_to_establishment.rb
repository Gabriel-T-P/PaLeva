class AddAdminUserToEstablishment < ActiveRecord::Migration[7.2]
  def change
    add_column :establishments, :admin_user_id, :integer
    add_foreign_key :establishments, :users, column: :admin_user_id
    add_index :establishments, :admin_user_id
  end
end
