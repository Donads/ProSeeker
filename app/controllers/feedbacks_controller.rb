class FeedbacksController < ApplicationController
  before_action :require_login

  def new
    @feedback = Feedback.new
  end

  def create
    @feedback = Feedback.new(feedback_params)
    @feedback.feedback_creator = current_user

    if @feedback.save
      redirect_to @feedback.project
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
end
