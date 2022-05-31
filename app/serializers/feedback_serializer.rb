# jsonapi-serializer
class FeedbackSerializer
  include JSONAPI::Serializer

  set_type :user_feedback
  attributes :score, :user_feedback
  attribute :feedback_source
  attribute :project_feedback, if: proc { |record| record.from_professional? }
end
