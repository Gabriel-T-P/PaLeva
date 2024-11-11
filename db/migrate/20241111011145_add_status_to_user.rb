class AddStatusToUser < ActiveRecord::Migration[7.2]
  def change
    add_column :users, :status, :integer
  end
end
