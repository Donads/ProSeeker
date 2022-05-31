# jsonapi-serializer
class BasicProjectSerializer
  include JSONAPI::Serializer

  has_many :project_proposals

  set_type :project
  attributes :title, :open_until
end
