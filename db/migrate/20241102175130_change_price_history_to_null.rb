class ChangePriceHistoryToNull < ActiveRecord::Migration[7.2]
  def change
    change_column_null :price_histories, :ended_at, true
  end
end
