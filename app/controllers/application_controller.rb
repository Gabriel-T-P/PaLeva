class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :check_user_establishment
  skip_before_action :check_user_establishment, if: :devise_controller?
  before_action :initialize_cart, if: -> { user_signed_in? }

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:first_name, :last_name, :cpf])
  end

  def check_user_establishment
    return unless user_signed_in?
    return unless current_user.establishment.nil?
    redirect_to new_establishment_path, alert: I18n.t('redirect_establishment_alert')
  end

  def initialize_cart
    @cart ||= Cart.new(session)
  end

  def set_establishment_check_user
    @establishment = Establishment.find(params[:establishment_id])
    return redirect_to root_path, alert: I18n.t('route_negated') unless @establishment.users.exists?(current_user.id)
  end

  def check_admin
    return redirect_to root_path, alert: I18n.t('route_negated') unless current_user.admin?
  end

end
