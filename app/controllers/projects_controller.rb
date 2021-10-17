class ProjectsController < ApplicationController
  before_action :require_user_login, except: %i[index show my_projects]
  before_action :require_login, only: %i[index show my_projects]
  before_action :professional_must_fill_profile
  before_action :set_project, only: %i[show edit update close finish]

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
    @projects = case current_user.role
                when 'user'
                  @project = Project.all
                when 'professional'
                  @projects = Project.where(status: :open)
                when 'admin'
                  @projects = Project.all
                end
  end

  def my_projects
    @projects = if current_user.professional?
                  Project.joins(:project_proposals).where(project_proposals: { user: current_user })
                else
                  Project.where(user: current_user)
                end

    render :index
  end

  def show
    if current_user.professional? || current_user.admin?
      @project_proposal = ProjectProposal.find_by(project: @project, user: current_user) || ProjectProposal.new
      @feedback = @project.feedback_from_professional(current_user)
    end

    if @project.user == current_user
      @project_proposals = if @project.finished?
                             ProjectProposal.left_outer_joins(:feedbacks).where(
                               project: @project, feedbacks: { feedback_source: [:from_user, nil] }
                             ).select('project_proposals.*, feedbacks.id AS feedback_id')
                           else
                             ProjectProposal.where(project: @project)
                           end
    elsif !@project.open? && (@project_proposal.approved? || @project_proposal.rated?)
      @project_proposals = ProjectProposal.where(project: @project)
    end

    if @project_proposals && !@project.open?
      @project_proposals = @project_proposals.where(
        status: %i[approved rated]
      )
    end
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

  def close
    unless @project.open?
      return redirect_to @project,
                         alert: 'Só é possível fechar projetos em aberto'
    end

    @project.closed!
    redirect_to @project, success: 'Projeto fechado com sucesso!'
  end

  def finish
    unless @project.closed?
      return redirect_to @project,
                         alert: 'Só é possível finalizar projetos fechados'
    end

    @project.finished!
    redirect_to @project, success: 'Projeto finalizado com sucesso!'
  end

  private

  def project_params
    params.require(:project).permit(:title, :description, :skills, :max_hourly_rate, :open_until, :attendance_type)
  end

  def require_user_login
    return if current_user&.user? || current_user&.admin?

    sign_out current_user
    redirect_to new_user_session_path, notice: 'Acesso restrito a usuários autenticados.'
  end

  def set_project
    @project = Project.find(params[:id])
  end
end
