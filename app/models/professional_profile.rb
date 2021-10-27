class ProfessionalProfile < ApplicationRecord
  belongs_to :user, optional: true
  belongs_to :knowledge_field
  has_one_attached :profile_photo

  validates :profile_photo, :full_name, :social_name, :description, :professional_qualification,
            :professional_experience, :birth_date, presence: true
  validates :user_id, uniqueness: {
    message: 'já possui um perfil cadastrado'
  }

  validate :birth_date_must_be_in_the_past

  def creator?(user_param)
    user == user_param
  end

  private

  def birth_date_must_be_in_the_past
    errors.add(:birth_date, 'deve estar no passado') if birth_date && birth_date >= Date.current
  end
end
