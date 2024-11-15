class Api::V1::OrdersController < ActionController::API
  rescue_from ActiveRecord::ActiveRecordError, with: :internal_error_500
  rescue_from ActiveRecord::RecordNotFound, with: :not_found_error_404

  def show
    order = Order.find(params[:id])
    render status: 200, json: {
      establishment_code: order.user.establishment.code,
      order: order.as_json(only: [:name, :code, :status, :created_at]),
      portions: order.portion_orders.as_json(except: [:created_at, :updated_at, :portion_id, :order_id], include: {portion: { only: [:id, :name, :description, :price] }})
    }
  end

  def index
    orders = fetch_orders
    if orders.empty?
      render status: 200, json: { result: I18n.t('.api_order_empty') }
    else
      render status: 200, json: orders
    end
  end
  
  def set_status_cooking
    @order = Order.find(params[:id])
    @order.update(status: 'cooking')
    render status: 200, json: @order.as_json(except: [:updated_at, :id])
  end
  

  private

  def fetch_orders
    return Order.all unless params[:status].present?
  
    orders = Order.where(status: params[:status])
    orders.presence || Order.all
  end

  def internal_error_500
    return render status: 500, json: {result: I18n.t('.api_order_internal_error')}
  end
  
  def not_found_error_404
    return render status: 404, json: {result: I18n.t('.api_order_not_found')}
  end

end