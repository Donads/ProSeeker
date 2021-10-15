class Feedback < ApplicationRecord
  belongs_to :project_proposal
  belongs_to :feedback_creator, class_name: 'User'
  belongs_to :feedback_receiver, class_name: 'User'

  validates :score, :user_feedback, presence: true
  validates :score, numericality: { only_integer: true, greater_than_or_equal_to: 1, less_than_or_equal_to: 5 }

  validate :professional_must_fill_project_feedback
  validate :user_can_not_fill_project_feedback
  validate :check_project_status

  private

  def professional_must_fill_project_feedback
    return unless feedback_creator&.professional?

    errors.add(:project_feedback, 'não pode ficar em branco') unless project_feedback.present?
  end

  def user_can_not_fill_project_feedback
    return unless feedback_creator&.user?

    errors.add(:project_feedback, 'não pode ser preenchido') if project_feedback.present?
  end

  def check_project_status
    unless project_proposal&.project&.finished?
      errors.add(:project_proposal_id,
                 'deve pertencer a um projeto finalizado')
    end
  end
end
