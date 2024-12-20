class BeveragesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_establishment_check_user
  before_action :check_admin
  before_action :set_beverage, only: [:show, :edit, :update, :destroy, :add_tag, :remove_tag]

  def new
    @beverage = Beverage.new
  end

  def show
    @portions = @beverage.portions
    @tags = @beverage.tags
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

  def add_tag
    tag = Tag.find(params[:tag_id])

    if @beverage.tags.include?(tag)
      redirect_to establishment_beverage_path(@establishment, @beverage), alert: t('.alert')
    else
      @beverage.tags << tag
      redirect_to establishment_beverage_path(@establishment, @beverage), notice: t('.notice')
    end
  end

  def remove_tag
    tag = Tag.find(params[:tag_id])
  
    if @beverage.tags.destroy(tag)
      redirect_to establishment_beverage_path(@establishment, @beverage), notice: t('.notice')
    else
      redirect_to establishment_beverage_path(@establishment, @beverage), alert: t('.alert')
    end
  end

  private

  
  def set_beverage
    @beverage = Beverage.find(params[:id])
  end
  
  def set_beverage_params
    params.require(:beverage).permit(:name, :description, :calories, :alcoholic, :image)
  end

end