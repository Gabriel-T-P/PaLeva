class OpeningHoursController < ApplicationController
  before_action :authenticate_user!
  before_action :set_establishment_check_user
  before_action :set_opening_hour, only: [:edit, :update]

  def new
    @opening_hour = @establishment.opening_hours.build
  end

  def create
    @opening_hour = @establishment.opening_hours.build(opening_hour_params)

    if @opening_hour.save
      flash[:notice] = t '.notice'
      redirect_to @establishment
    else
      flash.now[:alert] = t '.alert'
      render :new
    end
  end

  def edit
  end  
  
  def update
    if @opening_hour.update(opening_hour_params)
      flash[:notice] = t '.edit_success'
      redirect_to @establishment
    else
      flash.now[:alert] = t '.edit_fail'
      render :edit
    end
  end
  

  private

  def set_opening_hour
    @opening_hour = OpeningHour.find(params[:id])
  end

  def set_establishment_check_user
    @establishment = Establishment.find(params[:establishment_id])
    return redirect_to root_path, alert: I18n.t('route_negated') if @establishment.user != current_user
  end

  def opening_hour_params
    params.require(:opening_hour).permit(:day_of_week, :opening_time, :closing_time, :closed)
  end
end
