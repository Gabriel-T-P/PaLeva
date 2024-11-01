class PortionsController < ApplicationController
  before_action :set_parent
  before_action :set_portion, only: [:show, :edit, :update]
  before_action :set_establishment_check_user

  def show
  end

  def new
    @portion = @parent.portions.new
  end
  
  def create
    @portion = Portion.new(portion_params)
    @portion.item = @parent

    if @portion.save
      flash[:notice] = t '.notice'
      redirect_to polymorphic_path([@establishment, @parent])
    else
      flash.now[:alert] = t '.alert'
      render 'new'
    end
  end
  
  def edit
  end
  
  def update
    if @portion.update(portion_params)
      flash[:notice] = t '.notice'
      redirect_to establishment_item_portion_path(@establishment, @parent, @portion)
    else
      flash.now[:alert] = t '.alert'
      render 'edit'
    end
  end
  

  private

  def set_parent
    if params[:item_id]
      @parent = Item.find(params[:item_id])
    elsif params[:beverage_id]
      @parent = Beverage.find(params[:beverage_id])
    end
  end

  def set_portion
    @portion = Portion.find(params[:id])
  end

  def set_establishment_check_user
    @establishment = Establishment.find(params[:establishment_id])
    return redirect_to root_path, alert: I18n.t('route_negated') if @establishment.user != current_user
  end

  def portion_params
    params.require(:portion).permit(:name, :description, :price, :image)
  end

end
