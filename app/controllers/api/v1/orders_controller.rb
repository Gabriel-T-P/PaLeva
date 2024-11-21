class Api::V1::OrdersController < Api::V1::ApiController

  def show
    order = Order.find(params[:id])
    render status: 200, json: {
      establishment_code: order.user.establishment.code,
      order: order.as_json(except: [:id, :updated_at, :user_id]),
      portions: order.portion_orders.as_json(except: [:created_at, :updated_at, :portion_id, :order_id], include: {portion: { only: [:id, :name, :description, :price] }})
    }
  end

  def index
    orders = fetch_orders
    if orders.empty?
      render status: 200, json: { result: I18n.t('.api_order_empty') }
    else
      render status: 200, json: orders.as_json(except: [:updated_at, :user_id])
    end
  end
  
  def set_status_cooking
    order = Order.find(params[:id])
    order.update(status: 'cooking')
    order.update(cooking_at: DateTime.current)
    render status: 200, json: order.as_json(except: [:updated_at, :id, :user_id])
  end
  
  def set_status_ready
    order = Order.find(params[:id])
    order.update(status: 'ready')
    order.update(ready_at: DateTime.current)
    render status: 200, json: order.as_json(except: [:updated_at, :id, :user_id])
  end

  def set_status_canceled
    order = Order.find_by!(code: params[:order_code])
    order.update(status: 'canceled')
    order.update(canceled_at: DateTime.current)
    order.update(cancel_reason: params[:cancel_reason]) if params[:cancel_reason]
    render status: 200, json: order.as_json(except: [:updated_at, :id, :user_id])
  end


  private

  def fetch_orders
    return Order.all.order("created_at DESC") unless params[:status].present?
  
    orders = Order.where(status: params[:status])
    orders.presence || Order.all.order("created_at DESC")
  end

end