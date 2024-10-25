class RemoveReferenceFromTable < ActiveRecord::Migration[7.2]
  def change
    remove_reference :establishments, :users, foreign_key: true
    add_reference :establishments, :user, foreign_key: true
  end
end
