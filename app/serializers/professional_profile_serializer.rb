# ActiveModel::Serializer
class ProfessionalProfileSerializer < ActiveModel::Serializer
  include JSONAPI::Serializer

  belongs_to :user
  type 'professional_profile'

  attributes :social_name
end
