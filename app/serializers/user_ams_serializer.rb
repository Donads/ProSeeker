# ActiveModel::Serializer
class UserAmsSerializer < ActiveModel::Serializer
  has_one :professional_profile

  attributes :id, :email
end
