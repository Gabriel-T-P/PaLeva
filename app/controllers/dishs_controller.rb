class DishsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_establishment_check_user

  def new
    @dish = @establishment.dishes.build
  end
  
  private

  def set_establishment_check_user
    @establishment = Establishment.find(params[:establishment_id])
    return redirect_to root_path, alert: I18n.t('route_negated') if @establishment.user != current_user
  end

end