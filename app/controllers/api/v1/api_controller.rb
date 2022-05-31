class Api::V1::ApiController < ActionController::API
  rescue_from ActiveRecord::ActiveRecordError, with: :render_generic_error
  rescue_from ActiveRecord::RecordNotFound, with: :render_not_found

  private

  def render_generic_error(_e = nil)
    render status: :not_found, json: { message: 'Erro geral' }.as_json
  end

  def render_not_found(_e = nil)
    render status: 500, json: { message: 'Objeto não encontrado' }.as_json
  end
end
