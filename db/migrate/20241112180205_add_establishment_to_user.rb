class AddEstablishmentToUser < ActiveRecord::Migration[7.2]
  def change
    add_reference :users, :establishment, foreign_key: true
  end
end
