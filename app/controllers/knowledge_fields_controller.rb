class KnowledgeFieldsController < ApplicationController
  before_action :require_admin_login

  def index
    @knowledge_fields = KnowledgeField.all
  end

  def new
    @knowledge_field = KnowledgeField.new
  end

  def create
    @knowledge_field = KnowledgeField.new(knowledge_field_params)

    if @knowledge_field.save
      redirect_to knowledge_fields_path, success: 'Área de Conhecimento cadastrada com sucesso!'
    else
      render :new
    end
  end

  private

  def knowledge_field_params
    params.require(:knowledge_field).permit(:title)
  end

  def require_admin_login
    return if current_user&.admin?

    redirect_to root_path, alert: 'Acesso restrito a Administradores'
  end
end
