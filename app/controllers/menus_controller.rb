class MenusController < ApplicationController
  before_action :authenticate_user!
  before_action :check_admin
  before_action :set_menu, only: [:edit, :update]

  def index
    @menus = Menu.all
  end

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

  def edit
    @dishs = current_user.establishment.items.dish
    @beverages = current_user.establishment.items.beverage
  end
  
  def update
    if @menu.update(menu_params)
      flash[:notice] = t '.notice'
      redirect_to root_path
    else
      flash.now[:alert] = t '.alert'
      @dishs = current_user.establishment.items.dish
      @beverages = current_user.establishment.items.beverage
      render 'edit'
    end
  end
  

  private

  def set_menu
    @menu = Menu.find(params[:id])
  end

  def menu_params
    params.require(:menu).permit(:name, :start_date, :end_date, item_ids: [])
  end

end