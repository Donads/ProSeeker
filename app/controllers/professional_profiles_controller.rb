class ProfessionalProfilesController < ApplicationController
  before_action :require_professional_login, except: %i[show]
  before_action :professional_must_fill_profile, except: %i[new create show]
  before_action :set_professional_profile, only: %i[edit update show]
  before_action :set_projects, only: %i[show]
  before_action :check_authorization, only: %i[edit update]

  def new
    @professional_profile = ProfessionalProfile.new
  end

  def create
    @professional_profile = ProfessionalProfile.new(professional_profile_params)
    @professional_profile.user = current_user

    if @professional_profile.save
      redirect_to @professional_profile, success: 'Perfil cadastrado com sucesso!'
    else
      render :new
    end
  end

  def edit; end

  def update
    if @professional_profile.update(professional_profile_params)
      redirect_to @professional_profile, success: 'Perfil atualizado com sucesso!'
    else
      render :edit
    end
  end

  def show; end

  private

  def professional_profile_params
    params.require(:professional_profile).permit(:profile_photo, :full_name, :social_name, :description, :birth_date,
                                                 :professional_qualification, :professional_experience, :knowledge_field_id)
  end

  def require_professional_login
    return if current_user&.professional? || current_user&.admin?

    sign_out current_user
    redirect_to new_user_session_path, notice: 'Acesso restrito a profissionais autenticados.'
  end

  def set_professional_profile
    @professional_profile = ProfessionalProfile.find(params[:id])
  end

  def check_authorization
    return if current_user == @professional_profile.user

    redirect_to @professional_profile, alert: 'Somente o usuário pode atualizar o próprio perfil.'
  end

  def set_projects
    user = @professional_profile.user
    @projects = Project.joins(project_proposals: :feedbacks).where(project_proposals: { user:
      user }, feedbacks: { feedback_receiver: user }).select('projects.*, feedbacks.score AS score')
  end
end
