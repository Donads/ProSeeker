class ProjectProposalsController < ApplicationController
  def create
    @project_proposal = ProjectProposal.new(secure_params)
    project = Project.find(params[:project_id])
    @project_proposal.project = project
    @project_proposal.user = current_user

    if @project_proposal.save
      redirect_to @project_proposal.project, success: 'Proposta enviada com sucesso!'
    else
      render 'projects/show'
    end
  end

  def update
    @project_proposal = ProjectProposal.find(params[:id])

    if @project_proposal.update(secure_params)
      redirect_to @project_proposal.project, success: 'Proposta atualizada com sucesso!'
    else
      render 'projects/show'
    end
  end

  def destroy
    @project_proposal = ProjectProposal.find(params[:id])
    @project = @project_proposal.project

    if @project_proposal.destroy
      redirect_to @project, success: 'Proposta cancelada com sucesso!'
    else
      render 'projects/show'
    end
  end

  private

  def secure_params
    params.require(:project_proposal).permit(:reason, :hourly_rate, :weekly_hours, :deadline)
  end
end
