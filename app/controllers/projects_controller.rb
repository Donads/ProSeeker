class ProjectsController < ApplicationController
  before_action :professional_must_fill_profile

  def new
    @project = Project.new
  end

  def create
    @project = Project.new(project_params)
    @project.user = current_user

    if @project.save
      redirect_to project_path(@project), success: 'Projeto cadastrado com sucesso!'
    else
      render :new
    end
  end

  def index
    @projects = Project.all
  end

  def show
    @project = Project.find(params[:id])

    @project_proposals = ProjectProposal.where(project: @project) if @project.user == current_user

    @project_proposal = ProjectProposal.find_by(project: @project, user: current_user) || ProjectProposal.new
  end

  private

  def project_params
    params.require(:project).permit(:title, :description, :skills, :max_hourly_rate, :open_until, :attendance_type)
  end
end
