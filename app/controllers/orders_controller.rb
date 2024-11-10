class OrdersController < ApplicationController
  before_action :authenticate_user!

  def new
    @order = Order.new
  end
  
  def create
    @order = Order.new(order_params)
    @order.user = current_user

    @cart.items.each do |portion_id, item|
      portion = Portion.find(portion_id)
      PortionOrder.create!(portion: portion, order: @order, quantity: item['quantity'], observation: item['observation'])
    end

    if @order.save
      flash[:notice] = t '.notice'
      @cart.clear
      redirect_to @order
    else
      flash.now[:alert] = t '.alert'
      render 'new'
    end
  end
  
  def show
    @order = Order.find(params[:id])
  end
  

  private

  def order_params
    params.require(:order).permit(:name, :cpf, :email, :phone_number)
  end

end