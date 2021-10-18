class FeedbacksController < ApplicationController
  before_action :require_login
  before_action :professional_must_fill_profile
  before_action :set_feedback, only: %i[show]
  before_action :set_project_proposal, only: %i[new create]
  before_action :set_project, only: %i[new create]
  before_action :check_authorization, only: %i[new create]

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
      redirect_to @project, success: I18n.t('alerts.feedback_sent_successfully')
    else
      render :new
    end
  end

  def show; end

  def feedbacks_received
    @user = User.find(params[:user_id])
    @feedbacks = Feedback.where(feedback_receiver: @user)
  end

  private

  def feedback_params
    params.require(:feedback).permit(:score, :user_feedback, :project_feedback)
  end

  def set_feedback
    @feedback = Feedback.find(params[:id])
  end

  def set_project_proposal
    if @feedback
      @project_proposal = @feedback.project_proposal
    else
      project_proposal_id = params[:project_proposal_id] || params[:feedback][:project_proposal_id]
      @project_proposal = ProjectProposal.find_by_id(project_proposal_id)
    end

    return redirect_to root_path, alert: I18n.t('alerts.proposal_does_not_exist') if @project_proposal.nil?
  end

  def set_project
    @project = @project_proposal.project
  end

  def check_authorization
    unless @project.finished?
      return redirect_to @project, alert: I18n.t('alerts.project_situation_does_not_allow_feedbacks')
    end

    unless @project_proposal.approved? || @project_proposal.rated?
      return redirect_to @project, alert: I18n.t('alerts.proposal_situation_does_not_allow_feedbacks')
    end

    @feedback_creator = current_user

    if current_user.user? && @project.user == current_user
      @feedback_receiver = @project_proposal.user
      @feedback_source = :from_user
    elsif current_user.professional? && @project_proposal.user == current_user
      @feedback_receiver = @project.user
      @feedback_source = :from_professional
    else
      redirect_to root_path, alert: I18n.t('alerts.access_restricted_to_participants')
    end
  end
end
