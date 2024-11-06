class MenusController < ApplicationController
  before_action :authenticate_user!

  def new
    @menu = Menu.new
    @dishs = Item.dish
    @beverages = Item.beverage
  end
  
  def create
    @menu = Menu.new(menu_params)

    if @menu.save
      flash[:notice] = t '.notice'
      redirect_to root_path
    else
      flash.now[:alert] = t '.alert'
      @dishs = Item.dish
      @beverages = Item.beverage
      render 'new'
    end
  end

  private

  def menu_params
    params.require(:menu).permit(:name, item_ids: [])
  end
  
end