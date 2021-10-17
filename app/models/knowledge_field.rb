class KnowledgeField < ApplicationRecord
  has_many :professional_profiles

  validates :title, presence: true
  validates :title, uniqueness: true
end
