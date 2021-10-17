class ProjectProposalsController < ApplicationController
  before_action :set_project_proposal, only: %i[update destroy approve reject cancel]
  before_action :set_project, only: %i[update destroy approve reject cancel]
  before_action :check_project_creator, only: %i[approve reject]
  before_action :check_proposal_creator, only: %i[destroy cancel confirm_cancel]

  def create
    @project_proposal = ProjectProposal.new(project_proposal_params)
    @project = Project.find(params[:project_id])
    @project_proposal.project = @project
    @project_proposal.user = current_user

    if @project_proposal.save
      redirect_to @project_proposal.project, success: 'Proposta enviada com sucesso!'
    else
      redirect_to @project, warning: 'Erro ao inserir a proposta!'
    end
  end

  def update
    status_params = status_change_params
    case status_params[:status_change]
    when 'reject'
      check_project_creator
      return confirm_reject(status_params[:status_reason])
    when 'cancel'
      check_proposal_creator
      return confirm_cancel(status_params[:status_reason])
    end

    if @project_proposal.update(project_proposal_params)
      @project_proposal.pending!

      redirect_to @project, success: 'Proposta atualizada com sucesso!'
    else
      redirect_to @project, warning: 'Erro ao atualizar a proposta!'
    end
  end

  def destroy
    if @project_proposal.destroy
      redirect_to @project, success: 'Proposta cancelada com sucesso!'
    else
      redirect_to @project, warning: 'Erro ao cancelar a proposta!'
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
  end

  def cancel
    unless @project_proposal.can_be_canceled?
      redirect_to @project,
                  alert: 'Situação da proposta não permite cancelamento'
    end
  end

  private

  def project_proposal_params
    params.require(:project_proposal).permit(:reason, :hourly_rate, :weekly_hours, :deadline)
  end

  def status_change_params
    params.require(:project_proposal).permit(:status_reason, :status_change)
  end

  def set_project_proposal
    @project_proposal = ProjectProposal.find(params[:id])
  end

  def set_project
    @project = @project_proposal.project
  end

  def check_project_creator
    return if current_user == @project.user

    redirect_to @project, alert: 'Somente o dono do projeto pode realizar essa ação.'
  end

  def check_proposal_creator
    return if current_user == @project_proposal.user

    redirect_to @project, alert: 'Somente o próprio profissional pode realizar essa ação.'
  end

  def redirect_with_alert
    redirect_to @project, alert: @project_proposal.errors.full_messages.first
  end

  def confirm_reject(status_reason)
    return redirect_to @project, alert: 'Situação da proposta não permite alterações' unless @project_proposal.pending?

    @project_proposal.status_reason = status_reason
    return render :reject unless @project_proposal.valid?(:reject)

    @project_proposal.rejected!
    redirect_to @project, success: 'Proposta rejeitada com sucesso!'
  end

  def confirm_cancel(status_reason)
    unless @project_proposal.can_be_canceled?
      return redirect_to @project,
                         alert: 'Situação da proposta não permite alterações'
    end

    @project_proposal.status_reason = status_reason
    return render :cancel unless @project_proposal.valid?(:cancel)

    @project_proposal.canceled!
    redirect_to @project, success: 'Proposta cancelada com sucesso!'
  end
end
