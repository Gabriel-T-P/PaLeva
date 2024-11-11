class RegistrationsController < Devise::RegistrationsController
  def create
    user = User.find_by(email: sign_up_params[:email], cpf: sign_up_params[:cpf], status: 'pre_registered')
    if user
      user.update(sign_up_params.merge(status: 'active'))
      sign_in(user)
      redirect_to root_path, notice: 'Pré-Cadastro encontrado.'
    else
      super
    end
  end

  
  protected

  def after_sign_up_path_for(resource)
    new_establishment_path
  end
end