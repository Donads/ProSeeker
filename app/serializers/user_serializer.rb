# jsonapi-serializer
class UserSerializer < ActiveModel::Serializer
  include JSONAPI::Serializer

  attributes :id, :email

  attribute :average_score do |object|
    object.average_score_received?
  end

  attribute :social_name, if: proc { |record| record.professional_profile.present? } do |object|
    object.professional_profile.social_name
  end
end
