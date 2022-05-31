# JSONAPI-RB
class SerializableKnowledgeField < JSONAPI::Serializable::Resource
  type 'knowledge_field'

  attributes :title

  has_many :professional_profiles
end
