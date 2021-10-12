class ProjectsController < ApplicationController
  before_action :require_user_login, except: %i[index show]
  before_action :professional_must_fill_profile
  before_action :set_project, only: %i[show edit update]

  def new
    @project = Project.new
  end

  def create
    @project = Project.new(project_params)
    @project.user = current_user

    if @project.save
      redirect_to @project, success: 'Projeto cadastrado com sucesso!'
    else
      render :new
    end
  end

  def index
    @projects = Project.all
  end

  def show
    @project_proposals = ProjectProposal.where(project: @project) if @project.user == current_user

    @project_proposal = ProjectProposal.find_by(project: @project, user: current_user) || ProjectProposal.new
  end

  def edit
    redirect_to @project, alert: 'Somente o autor do projeto pode editá-lo' unless @project.user == current_user
  end

  def update
    if @project.update(project_params)
      redirect_to @project, success: 'Projeto atualizado com sucesso!'
    else
      render :edit
    end
  end

  private

  def project_params
    params.require(:project).permit(:title, :description, :skills, :max_hourly_rate, :open_until, :attendance_type)
  end

  def require_user_login
    unless current_user&.user? || current_user&.admin?
      sign_out current_user
      redirect_to new_user_session_path, notice: 'Acesso restrito a usuários autenticados.'
    end
  end

  def set_project
    @project = Project.find(params[:id])
  end
end
