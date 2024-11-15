class Api::V1::OrdersController < ActionController::API

  def show
    begin
      @order = Order.find(params[:id])
      render status: 200, json: {
        establishment_code: @order.user.establishment.code,
        order: @order.as_json(only: [:name, :code, :status, :created_at]),
        portions: @order.portion_orders.as_json(except: [:created_at, :updated_at, :portion_id, :order_id], include: {portion: { only: [:id, :name, :description, :price] }})
      }
    rescue
      render status: 404, json: {result: I18n.t('.api_order_not_found')}
    end
  end

  def index
    if params[:status].present?
      order = Order.where(status: params[:status])
      if order.empty?
        order = Order.all
        return render status: 200, json: {result: I18n.t('.api_order_empty')} if order.empty?
        render status: 200, json: order
      else
        render status: 200, json: order
      end
    else
      order = Order.all
      return render status: 200, json: {result: I18n.t('.api_order_empty')} if order.empty?
      render status: 200, json: order
    end
  end
  
end