class MenusController < ApplicationController
  before_action :authenticate_user!
  before_action :check_admin

  def new
    @menu = Menu.new
    @dishs = current_user.establishment.items.dish
    @beverages = current_user.establishment.items.beverage
  end
  
  def create
    @menu = Menu.new(menu_params)
    @menu.establishment = current_user.establishment

    if @menu.save
      flash[:notice] = t '.notice'
      redirect_to root_path
    else
      flash.now[:alert] = t '.alert'
      @dishs = current_user.establishment.items.dish
      @beverages = current_user.establishment.items.beverage
      render 'new'
    end
  end

  private

  def menu_params
    params.require(:menu).permit(:name, item_ids: [])
  end

end