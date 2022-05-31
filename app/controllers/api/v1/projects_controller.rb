class Api::V1::ProjectsController < Api::V1::ApiController
  def index
    @projects = Project.all

    return render_not_found if @projects.nil?

    # render status: :ok, json: @projects
    render status: :ok, json: ProjectSerializer.new(@projects).serializable_hash
  end

  def show
    @project = Project.find(params[:id])

    return render status: :ok, json: @project.as_json if @project.id == 1
    return render :show, status: :ok if @project.id == 2

    render status: :ok, json: @project.as_json(only: %i[title status description])
  end
end
