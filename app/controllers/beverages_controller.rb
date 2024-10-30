class BeveragesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_establishment_check_user
  before_action :set_beverage, only: [:show, :edit, :update, :destroy]

  def new
    @beverage = Beverage.new
  end

  def show
    @portions = @beverage.portions
  end

  def create
    @beverage = Beverage.new(set_beverage_params)
    @beverage.item_type = :beverage
    @beverage.establishment = @establishment

    if @beverage.save
      flash[:notice] = t '.beverage_notice'
      redirect_to @establishment
    else
      flash.now[:alert] = t '.beverage_alert'
      render 'new'
    end
  end
  
  def edit
  end
  
  def update
    if @beverage.update(set_beverage_params)
      flash[:notice] = t '.edit_success'
      redirect_to @establishment
    else
      flash.now[:alert] = t '.edit_fail'
      render 'edit'
    end
  end

  def destroy
    if @beverage.destroy
      flash[:notice] = t '.delete_success'
      redirect_to @establishment
    else
      flash[:alert] = t '.delete_fail'
      redirect_to @establishment
    end
  end

  private

  
  def set_beverage
    @beverage = Beverage.find(params[:id])
  end

  def set_establishment_check_user
    @establishment = Establishment.find(params[:establishment_id])
    return redirect_to root_path, alert: I18n.t('route_negated') if @establishment.user != current_user
  end
  
  def set_beverage_params
    params.require(:beverage).permit(:name, :description, :calories, :alcoholic, :image)
  end

end