class AddUseLimitToPromotion < ActiveRecord::Migration[7.2]
  def change
    add_column :promotions, :use_limit, :integer
  end
end
