class PortionsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_parent
  before_action :set_portion, only: [:show, :edit, :update, :destroy, :set_active, :set_unactive]
  before_action :set_establishment_check_user

  def show
    @portion_order = @portion.portion_orders.new
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
      redirect_to polymorphic_path([@establishment, @parent, @portion])
    else
      flash.now[:alert] = t '.alert'
      render 'edit'
    end
  end
  
  def destroy
    if @portion.destroy
      flash[:notice] = t '.notice'
      redirect_to polymorphic_path([@establishment, @parent])
    else
      flash[:alert] = t '.alert'
      redirect_to polymorphic_path([@establishment, @parent, @portion])
    end
  end
  
  def set_unactive
    if @portion.update(active: false)
      flash[:notice] = t '.notice'
    else
      flash[:alert] = t '.alert'
    end
    redirect_to polymorphic_path([@establishment, @parent])
  end
  
  def set_active
    if @portion.update(active: true)
      flash[:notice] = t '.notice'
    else
      flash[:alert] = t '.alert'
    end
    redirect_to polymorphic_path([@establishment, @parent])
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
    return redirect_to root_path, alert: I18n.t('route_negated') unless @establishment.users.exists?(current_user.id)
  end

  def portion_params
    params.require(:portion).permit(:name, :description, :price, :image, :active)
  end

end
