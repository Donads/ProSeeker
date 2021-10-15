class ProfessionalProfilesController < ApplicationController
  before_action :require_professional_login, except: %i[show]
  before_action :professional_must_fill_profile, except: %i[new create show]
  before_action :set_professional_profile, only: %i[edit show]
  before_action :set_projects, only: %i[show]

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

  # TODO: Implement edit and update tests and functionality
  def edit; end

  def update; end

  def show; end

  private

  def professional_profile_params
    params.require(:professional_profile).permit(:full_name, :social_name, :description, :birth_date,
                                                 :professional_qualification, :professional_experience)
  end

  def require_professional_login
    return if current_user&.professional? || current_user&.admin?

    sign_out current_user
    redirect_to new_user_session_path, notice: 'Acesso restrito a profissionais autenticados.'
  end

  def set_professional_profile
    @professional_profile = ProfessionalProfile.find(params[:id])
  end

  def set_projects
    # @projects = Project.joins(:project_proposals).where(project_proposals: { user: @professional_profile.user })
    # @projects = Project.joins(:project_proposals).where(project_proposals: { user: @professional_profile.user }).select(
    #   'projects.*, project_proposals.reason, project_proposals.status AS proposal_status'
    # )
    @projects = Project.joins(project_proposals: :feedbacks).where(project_proposals: { user:
      @professional_profile.user }).select('projects.*, feedbacks.score AS score')
  end
end
