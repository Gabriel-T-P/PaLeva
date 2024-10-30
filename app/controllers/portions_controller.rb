class PortionsController < ApplicationController
  before_action :set_parent
  before_action :set_establishment_check_user

  def new
    @portion = @parent.portions.new
  end
  

  private

  def set_parent
    if params[:item_id]
      @parent = Item.find(params[:item_id])
    elsif params[:beverage_id]
      @parent = Beverage.find(params[:beverage_id])
    end
  end

  def set_establishment_check_user
    @establishment = Establishment.find(params[:establishment_id])
    return redirect_to root_path, alert: I18n.t('route_negated') if @establishment.user != current_user
  end

  def portion_params
    params.require(:portion).permit(:name, :description, :price, :image)
  end

end
