class ProjectProposalsController < ApplicationController
  before_action :set_project_proposal, only: %i[update destroy approve reject]
  before_action :set_project, only: %i[update destroy approve reject]

  def create
    @project_proposal = ProjectProposal.new(project_proposal_params)
    @project = Project.find(params[:project_id])
    @project_proposal.project = @project
    @project_proposal.user = current_user

    if @project_proposal.save
      redirect_to @project_proposal.project, success: 'Proposta enviada com sucesso!'
    else
      redirect_to @project, warning: 'Erro ao inserir a proposta!'
      # render 'projects/show'
    end
  end

  def update
    if @project_proposal.update(project_proposal_params)
      redirect_to @project, success: 'Proposta atualizada com sucesso!'
    else
      # TODO: Find out why the flash error validation doesn't reach this part (update, create and maybe destroy)
      redirect_to @project, warning: 'Erro ao atualizar a proposta!'
      # render 'projects/show'
    end
  end

  def destroy
    if @project_proposal.destroy
      redirect_to @project, success: 'Proposta cancelada com sucesso!'
    else
      redirect_to @project, warning: 'Erro ao cancelar a proposta!'
      # render 'projects/show'
    end
  end

  def approve
    return redirect_to @project, alert: 'Situação da proposta não permite alterações' unless @project_proposal.pending?

    return redirect_with_alert unless @project_proposal.valid?

    @project_proposal.approved!
    redirect_to @project, success: 'Proposta aprovada com sucesso!'
  end

  def reject
    return redirect_to @project, alert: 'Situação da proposta não permite alterações' unless @project_proposal.pending?

    return redirect_with_alert unless @project_proposal.valid?

    @project_proposal.rejected!
    redirect_to @project, success: 'Proposta rejeitada com sucesso!'
  end

  private

  def project_proposal_params
    params.require(:project_proposal).permit(:reason, :hourly_rate, :weekly_hours, :deadline)
  end

  def set_project_proposal
    @project_proposal = ProjectProposal.find(params[:id])
  end

  def set_project
    @project = @project_proposal.project
  end

  def redirect_with_alert
    redirect_to @project, alert: @project_proposal.errors.full_messages.first
  end
end
