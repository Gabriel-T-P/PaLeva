class ItemsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_establishment_check_user
  before_action :check_admin
  before_action :set_item, only: [:show, :edit, :update, :destroy, :add_tag, :remove_tag]

  def index
    if params[:query].present?
      @items = @establishment.items.where("name LIKE :query OR description LIKE :query", query: "%#{params[:query]}%")
    else
      @items = @establishment.items
    end
  end

  def show
    @portions = @item.portions
    @tags = @item.tags
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

  def add_tag
    tag = Tag.find(params[:tag_id])

    if @item.tags.include?(tag)
      redirect_to establishment_item_path(@establishment, @item), alert: t('.alert')
    else
      @item.tags << tag
      redirect_to establishment_item_path(@establishment, @item), notice: t('.notice')
    end    
  end

  def remove_tag
    tag = Tag.find(params[:tag_id])
  
    if @item.tags.destroy(tag)
      redirect_to establishment_item_path(@establishment, @item), notice: t('.notice')
    else
      redirect_to establishment_item_path(@establishment, @item), alert: t('.alert')
    end
  end

  private


  def set_item
    @item = Item.find(params[:id])
  end

  def set_item_params
    params.require(:item).permit(:name, :description, :calories, :image)
  end  

end