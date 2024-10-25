class OpeningHoursController < ApplicationController
  before_action :authenticate_user!
  before_action :set_establishment_check_user

  def new
    @opening_hour = @establishment.opening_hours.build
  end

  def create
    @opening_hour = @establishment.opening_hours.build(opening_hour_params)

    if @opening_hour.save
      flash[:notice] = 'Horário criado com sucesso'
      redirect_to establishment_path(@establishment)
    else
      flash.now[:alert] = 'Algo deu errado'
      render :new
    end
  end

  private

  def set_establishment_check_user
    @establishment = Establishment.find(params[:establishment_id])
    return redirect_to root_path, alert: I18n.t('route_negated') if @establishment.user != current_user
  end

  def opening_hour_params
    params.require(:opening_hour).permit(:day_of_week, :opening_time, :closing_time, :closed)
  end
end
