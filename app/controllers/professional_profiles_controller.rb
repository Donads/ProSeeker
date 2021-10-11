class ProfessionalProfilesController < ApplicationController
  before_action :require_professional_login
  before_action :professional_must_fill_profile, except: %i[new create show]

  def new
    @professional_profile = ProfessionalProfile.new
  end

  def create
    @professional_profile = ProfessionalProfile.new(secure_params)
    @professional_profile.user = current_user

    if @professional_profile.save
      redirect_to @professional_profile, success: 'Perfil cadastrado com sucesso!'
    else
      render :new
    end
  end

  def show
    @professional_profile = ProfessionalProfile.find(params[:id])
  end

  private

  def secure_params
    params.require(:professional_profile).permit(:full_name, :social_name, :description, :birth_date,
                                                 :professional_qualification, :professional_experience)
  end

  def require_professional_login
    sign_out current_user if current_user&.user?

    unless current_user&.professional?
      redirect_to new_user_session_path, notice: 'Acesso restrito a profissionais autenticados.'
    end
  end
end