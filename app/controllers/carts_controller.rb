class CartsController < ApplicationController
  before_action :authenticate_user!

  def remove_item
    portion_id = params.require(:portion_id)
    @cart.remove_item(portion_id)
    flash[:notice] = t '.notice'
    redirect_back(fallback_location: root_path)
  end
  
end