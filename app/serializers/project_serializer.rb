# jsonapi-serializer
class ProjectSerializer
  include JSONAPI::Serializer

  has_many :project_proposals

  attributes :title, :open_until
end
