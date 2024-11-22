class RemovePromotionFromPortion < ActiveRecord::Migration[7.2]
  def change
    remove_reference :portions, :promotion, foreign_key: true
  end
end
