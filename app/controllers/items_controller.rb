class ItemsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_establishment_check_user
  before_action :set_item, only: [:show, :edit, :update, :destroy]

  def index
    if params[:query].present?
      @items = Item.where("name LIKE :query OR description LIKE :query", query: "%#{params[:query]}%")
    else
      @items = Item.all
    end
  end

  def show
  end

  def new
    @item = Item.new
  end
  
  def create
    @item = Item.new(set_item_params)
    @item.establishment = @establishment
    @item.item_type = :dish

    if @item.save
      flash[:notice] = t '.dish_notice'
      redirect_to @establishment
    else
      flash.now[:alert] = t '.dish_alert'
      render 'new'
    end
  end

  def edit
  end

  def update
    if @item.update(set_item_params)
      flash[:notice] = t '.edit_success'
      redirect_to @establishment
    else
      flash.now[:alert] = t '.edit_fail'
      render 'edit'
    end
  end
  
  def destroy
    if @item.destroy
      flash[:notice] = t '.delete_success'
      redirect_to @establishment
    else
      flash[:alert] = t '.delete_fail'
      redirect_to @establishment
    end
  end


  private

  def set_item
    @item = Item.find(params[:id])
  end

  def set_establishment_check_user
    @establishment = Establishment.find(params[:establishment_id])
    return redirect_to root_path, alert: I18n.t('route_negated') if @establishment.user != current_user
  end

  def set_item_params
    params.require(:item).permit(:name, :description, :calories, :image)
  end  

end