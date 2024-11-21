class AddPromotionToPortion < ActiveRecord::Migration[7.2]
  def change
    add_reference :portions, :promotion, foreign_key: true
  end
end
