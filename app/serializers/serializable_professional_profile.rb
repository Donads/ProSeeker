# JSONAPI-RB
class SerializableProfessionalProfile < JSONAPI::Serializable::Resource
  type 'professional_profile'

  attributes :social_name, :user_id

  belongs_to :knowledge_field
end
