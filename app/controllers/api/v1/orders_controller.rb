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

end

as_json(include: { posts: { include: { comments: {only: :body } }, only: :title } })
