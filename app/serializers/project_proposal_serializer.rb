# jsonapi-serializer
class ProjectProposalSerializer
  include JSONAPI::Serializer

  belongs_to :project
  belongs_to :user
  has_many :feedbacks

  attributes :reason, :status
  attribute :status_reason, if: proc { |record|
    record.status_reason.present?
  }
end
