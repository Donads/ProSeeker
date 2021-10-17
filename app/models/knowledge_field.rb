class KnowledgeField < ApplicationRecord
  validates :title, presence: true
  validates :title, uniqueness: true
end
