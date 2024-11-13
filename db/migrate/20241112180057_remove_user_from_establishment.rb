class RemoveUserFromEstablishment < ActiveRecord::Migration[7.2]
  def change
    remove_reference :establishments, :user, null: false, foreign_key: true
  end
end
