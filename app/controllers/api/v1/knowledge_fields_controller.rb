class Api::V1::KnowledgeFieldsController < Api::V1::ApiController
  deserializable_resource :knowledge_field

  def index
    @knowledge_fields = KnowledgeField.all

    return render_not_found if @knowledge_fields.nil?

    render jsonapi: @knowledge_fields, include: [:professional_profiles],
           fields: { professional_profile: [:social_name] },
           status: :ok
  end

  def show
    @knowledge_field = KnowledgeField.find(params[:id])

    render status: :ok,
           json: @knowledge_field.as_json(include: { professional_profiles: { only: %i[id social_name
                                                                                       user_id] } })
    # render status: :ok, json: @knowledge_field
  end
end
