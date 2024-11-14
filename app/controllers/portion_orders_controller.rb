class PortionOrdersController < ApplicationController
  before_action :authenticate_user!

  def create
    @portion_order = PortionOrder.new(params.require(:portion_order).permit(:portion_id, :quantity, :observation))
    @portion_order.order = Order.new(name: 'Default', phone_number: '1', user: current_user)
  
    if @portion_order.valid?
      @cart.add_item(@portion_order)
      flash[:notice] = t('.notice')
      redirect_to root_path
    else
      flash[:error] = @portion_order.errors.full_messages
      redirect_to polymorphic_path([current_user.establishment, @portion_order.portion.item, @portion_order.portion])
    end
  end

end