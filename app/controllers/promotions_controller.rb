class PromotionsController < ApplicationController
  before_action :extract_portions, only: [:new]

  def new
    @promotion = Promotion.new()
    
  end
  

  private

  def extract_portions
    @portions_dish = current_user.establishment.items.dish.flat_map(&:portions)
    @portions_beverage = current_user.establishment.items.beverage.flat_map(&:portions)
  end

end