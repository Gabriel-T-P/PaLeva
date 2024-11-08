class PortionOrdersController < ApplicationController

  def create
    @portion_order = PortionOrder.new(params.require(:portion_order).permit(:portion_id, :quantity, :observation))
    @portion_order.order = current_order

    if @portion_order.save
      flash[:notice] = "Object successfully created"
      redirect_to root_path
    else
      flash.now[:alert] = "Something went wrong"
      render 'portions/show'
    end
  end
  

end