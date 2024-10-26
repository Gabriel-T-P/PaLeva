class EstablishmentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_establishment_check_user, only: [:edit, :show]
  skip_before_action :check_admin_establishment, only: [:create, :new]

  def show
    @items = @establishment.items
  end

  def new
    return redirect_to root_path, alert: t('.alert') if current_user.establishment.present?
    @establishment = Establishment.new
  end

  def create
    @establishment = Establishment.new(set_params)
    @establishment.user = current_user

    if @establishment.save
      flash[:notice] = t '.notice'
      redirect_to @establishment
    else
      flash.now[:alert] = t '.alert'
      render 'new'
    end
  end

  def edit
  end
  
  private

  def set_establishment_check_user
    @establishment = Establishment.find(params[:id])
    return redirect_to root_path, alert: I18n.t('route_negated') if @establishment.user != current_user
  end

  def set_params
    params.require(:establishment).permit(:corporate_name, :trade_name, :cnpj, :full_address, :email, :phone_number)
  end
  
end