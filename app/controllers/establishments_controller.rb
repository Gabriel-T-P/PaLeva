class EstablishmentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_establishment_check_user, only: [:edit, :update, :show]
  skip_before_action :check_user_establishment, only: [:create, :new]

  def show
    @dishs = @establishment.items.dish
    @beverages = @establishment.items.beverage
  end

  def new
    return redirect_to root_path, alert: t('.alert') if current_user.establishment.present?
    @establishment = Establishment.new
  end

  def create
    @establishment = Establishment.new(set_params)

    if @establishment.save
      @establishment.users << current_user

      flash[:notice] = t '.notice'
      redirect_to @establishment
    else
      flash.now[:alert] = t '.alert'
      render 'new'
    end
  end

  def edit
  end

  def update
    if @establishment.update(set_params)
      flash[:notice] = t '.notice'
      redirect_to @establishment
    else
      flash[:alert] = t '.alert'
      render 'edit'
    end
  end
  
  
  private

  def set_establishment_check_user
    @establishment = Establishment.find(params[:id])
    return redirect_to root_path, alert: I18n.t('route_negated') unless @establishment.users.exists?(current_user.id)
  end

  def set_params
    params.require(:establishment).permit(:corporate_name, :trade_name, :cnpj, :full_address, :email, :phone_number)
  end
  
end