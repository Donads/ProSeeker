class FeedbacksController < ApplicationController
  before_action :require_login
  before_action :set_project_proposal, only: %i[new create]
  before_action :set_project, only: %i[new create]
  before_action :check_authorization, only: %i[new create]

  def new
    @feedback = Feedback.new(project: @project, feedback_creator: @feedback_creator,
                             feedback_receiver: @feedback_receiver)
  end

  def create
    @feedback = Feedback.new(feedback_params)
    @feedback.project = @project
    @feedback.feedback_creator = @feedback_creator
    @feedback.feedback_receiver = @feedback_receiver

    if @feedback.save
      @project_proposal.rated!
      redirect_to @feedback.project, success: 'Avaliação enviada com sucesso!'
    else
      render :new
    end
  end

  private

  def feedback_params
    params.require(:feedback).permit(:score, :user_feedback, :project_feedback)
  end

  def require_login
    return if current_user

    redirect_to new_user_session_path, notice: 'Acesso restrito a usuários/profissionais autenticados.'
  end

  def set_project_proposal
    @project_proposal = ProjectProposal.find(params[:project_proposal_id] || params[:feedback][:project_proposal_id])
  end

  def set_project
    @project = @project_proposal.project
  end

  def check_authorization
    redirect_to @project, alert: 'Situação do projeto não permite avaliação.' unless @project.finished?
    redirect_to @project, alert: 'Situação da proposta não permite avaliação.' unless @project_proposal.approved?

    if current_user.user? && @project.user == current_user
      @feedback_creator = current_user
      @feedback_receiver = @project_proposal.user
    elsif current_user.professional? && @project_proposal.user == current_user
      @feedback_creator = @project.user
      @feedback_receiver = current_user
    else
      redirect_to root_path, alert: 'Acesso restrito aos participantes.'
    end
  end
end