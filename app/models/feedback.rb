class Feedback < ApplicationRecord
  belongs_to :project
  belongs_to :feedback_creator, class_name: 'User'
  belongs_to :feedback_receiver, class_name: 'User'

  validates :score, :user_feedback, presence: true

  validate :professional_must_fill_project_feedback
  validate :check_project_status

  private

  def professional_must_fill_project_feedback
    return unless feedback_creator&.professional?

    errors.add(:project_feedback, 'não pode ficar em branco') unless project_feedback.present?
  end

  def check_project_status
    errors.add(:project_id, 'deve estar finalizado') unless project&.finished?
  end
end
