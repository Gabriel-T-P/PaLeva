class CartsController < ApplicationController
  
  def remove_item
    portion_id = params[:portion_id]
    @cart.remove_item(portion_id)
    redirect_to root_path, notice: 'Item removido com sucesso.'
  end
  
end