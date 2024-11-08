class PortionOrdersController < ApplicationController

  def create
    @portion_order = PortionOrder.new(params.require(:portion_order).permit(:portion_id, :quantity, :observation))
    @portion_order.order = current_order

    if @portion_order.save
      flash[:notice] = "Object successfully created"
      redirect_to root_path
    else
      flash[:error] = @portion_order.errors.full_messages
      redirect_to polymorphic_path([current_user.establishment, @portion_order.portion.item, @portion_order.portion])
    end
  end

end