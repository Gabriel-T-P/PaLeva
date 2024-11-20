class PortionOrdersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_portion_and_check_active
  before_action :check_menu

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


  private

  def set_portion_and_check_active
    portion_id = (params.require(:portion_order).permit(:portion_id)['portion_id'])
    @portion = Portion.find(portion_id)
    return redirect_to root_path, alert: t('.inactive_alert'), status: 412 unless @portion.active
  end
  
  def check_menu
    @item = @portion.item
    return redirect_to root_path, alert: t('.no_menu_alert'), status: 412 if @item.menus.empty?

    @item.menus.each do |menu|
      if menu.start_date
        return redirect_to root_path, alert: t('.menu_out_of_date_alert'), status: 412 unless Date.current > menu.start_date && Date.current < menu.end_date
      end
    end
  end

end