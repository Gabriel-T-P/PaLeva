class OrdersController < ApplicationController
  before_action :authenticate_user!, except: [:display]
  before_action :set_order, only: [:edit, :update, :show]
  before_action :check_employee, only: [:edit, :update, :show]

  def index
    if current_user.admin?
      @orders = Order.all
    else
      @orders = current_user.orders
    end
  end

  def show
    return redirect_to root_path if params[:id] == "display"
  end

  def new
    @order = Order.new
  end
  
  def create
    @order = Order.new(order_params)
    @order.user = current_user

    if @order.valid?
      @cart.items.each do |portion_id, item|
        portion = Portion.find(portion_id)
        PortionOrder.create!(portion: portion, order: @order, quantity: item['quantity'], observation: item['observation'])
      end
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
  
  def edit
  end

  def update
    if @order.update(order_params)
      flash[:notice] = t '.notice'
      redirect_to @order
    else
      flash[:alert] = t '.alert'
      render 'edit'
    end
  end

  def display
    begin
      order_code = params.require(:code)
      @order = Order.find_by!("code = ?", order_code)
    rescue
      return redirect_to root_path, alert: t('.order_not_found')
    end
    @establishment = @order.user.establishment
  end

  private

  def set_order
    begin
      @order = Order.find(params[:id])
    rescue
      return redirect_to root_path, alert: t('.order_not_found')
    end
  end

  def check_employee
    if current_user.employee?
      return redirect_to root_path, alert: t('.access_negated') if @order.user_id != current_user.id
    end
  end

  def order_params
    params.require(:order).permit(:name, :cpf, :email, :phone_number)
  end

end