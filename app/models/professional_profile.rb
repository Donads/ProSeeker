class ProfessionalProfile < ApplicationRecord
  belongs_to :user, optional: true

  validates :full_name, :social_name, :description, :professional_qualification,
            :professional_experience, :birth_date, presence: true
end
