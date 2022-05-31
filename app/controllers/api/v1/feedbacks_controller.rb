class Api::V1::FeedbacksController < Api::V1::ApiController
  def index
    @feedbacks = Feedback.all

    return render_not_found if @feedbacks.nil?
    return render status: :ok, json: { message: 'Ainda não há Feedbacks cadastrados' }.as_json if @feedbacks.empty?

    render status: :ok, json: @feedbacks.as_json
  end

  def show
    @feedback = Feedback.find(params[:id])

    render status: :ok, json: @feedback.as_json
  end
end
