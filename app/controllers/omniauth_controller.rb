class OmniauthController < ApplicationController
  before_action :set_user, only: %i[facebook github google_oauth2]

  def facebook
    return failure unless @user.persisted?

    sign_in_and_redirect @user
  end

  def github
    return failure unless @user.persisted?

    sign_in_and_redirect @user
  end

  def google_oauth2
    return failure unless @user.persisted?

    sign_in_and_redirect @user
  end

  def failure
    redirect_to new_user_registration_url,
                error: 'There was a problem signing you in. Please register or try signing in later.'
  end

  private

  def set_user
    @user = User.create_from_provider_data(request.env['omniauth.auth'])
  end
end
