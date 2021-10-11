class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?

  add_flash_types :success

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:role])
  end

  def professional_must_fill_profile
    return unless current_user&.professional?

    return if current_user&.professional_profile

    flash[:notice] =
      'Profissionais devem preencher o perfil por completo antes de terem acesso às funcionalidades da plataforma.'
    redirect_to new_professional_profile_path
  end
end
