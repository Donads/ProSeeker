class FeedbacksController < ApplicationController
  before_action :require_login
  before_action :set_project_proposal, only: %i[new create show]
  before_action :set_project, only: %i[new create show]
  before_action :check_authorization, only: %i[new create show]

  def new
    @feedback = Feedback.new(project_proposal: @project_proposal, feedback_creator: @feedback_creator,
                             feedback_receiver: @feedback_receiver)
  end

  def create
    @feedback = Feedback.new(feedback_params)
    @feedback.project_proposal = @project_proposal
    @feedback.feedback_creator = @feedback_creator
    @feedback.feedback_receiver = @feedback_receiver
    @feedback.feedback_source = @feedback_source

    if @feedback.save
      @project_proposal.rated! if @feedback.from_user?
      redirect_to @project, success: 'Avaliação enviada com sucesso!'
    else
      render :new
    end
  end

  def show; end

  private

  def feedback_params
    params.require(:feedback).permit(:score, :user_feedback, :project_feedback)
  end

  def require_login
    return if current_user

    redirect_to new_user_session_path, notice: 'Acesso restrito a usuários/profissionais autenticados.'
  end

  def set_project_proposal
    project_proposal_id = params[:project_proposal_id] || params[:feedback][:project_proposal_id]
    @project_proposal = ProjectProposal.find_by_id(project_proposal_id)

    return redirect_to root_path, alert: 'Proposta não existe' if @project_proposal.nil?
  end

  def set_project
    @project = @project_proposal.project
  end

  def check_authorization
    return redirect_to @project, alert: 'Situação do projeto não permite avaliação.' unless @project.finished?

    unless @project_proposal.approved? || @project_proposal.rated?
      return redirect_to @project, alert: 'Situação da proposta não permite avaliação.'
    end

    @feedback = @project.feedback_from_professional(current_user)
    return render :show if @project_feedback

    @feedback_creator = current_user

    if current_user.user? && @project.user == current_user
      @feedback_receiver = @project_proposal.user
      @feedback_source = :from_user
    elsif current_user.professional? && @project_proposal.user == current_user
      @feedback_receiver = @project.user
      @feedback_source = :from_professional
    else
      redirect_to root_path, alert: 'Acesso restrito aos participantes.'
    end
  end
end
