class Api::V1::ProjectProposalsController < Api::V1::ApiController
  def index
    @project_proposals = ProjectProposal.all

    return render_not_found if @project_proposals.nil?

    options = { include: %i[project user feedbacks] }
    render status: :ok, json: ProjectProposalSerializer.new(@project_proposals, options).serializable_hash
    # render status: :ok, json: @project_proposals.as_json
    # render :index, status: :ok
  end

  def show
    @project_proposal = ProjectProposal.find(params[:id])

    return render status: :ok, json: @project_proposal.as_json if @project_proposal.id == 1

    render status: :ok, json: @project_proposal.as_json(only: %i[id reason status status_reason])
  end
end
