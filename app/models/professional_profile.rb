class ProfessionalProfile < ApplicationRecord
  belongs_to :user, optional: true

  validates :full_name, :social_name, :description, :professional_qualification,
            :professional_experience, :birth_date, presence: true

  validate :birth_date_must_be_in_the_past

  private

  def birth_date_must_be_in_the_past
    errors.add(:birth_date, 'deve estar no passado') if birth_date && birth_date >= Date.current
  end
end
