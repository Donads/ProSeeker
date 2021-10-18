class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?

  add_flash_types :success, :warning

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:role])
  end

  def require_login
    return if current_user

    redirect_to root_path, alert: I18n.t('alerts.user_not_authenticated')
  end

  def require_admin_login
    return if current_user&.admin?

    redirect_to root_path, alert: I18n.t('alerts.access_restricted_to_admins')
  end

  def professional_must_fill_profile
    return unless current_user&.professional?

    return if current_user&.professional_profile

    flash[:notice] = I18n.t('alerts.professionals_need_to_fill_profile')
    redirect_to new_professional_profile_path
  end
end
