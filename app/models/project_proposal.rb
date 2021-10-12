class ProjectProposal < ApplicationRecord
  belongs_to :project
  belongs_to :user

  enum status: { pending: 10, approved: 20, rejected: 30 }

  validates :reason, :hourly_rate, :weekly_hours, :deadline, :status, presence: true
  validates :hourly_rate, :weekly_hours, numericality: { greater_than: 0 }
  validates :weekly_hours, numericality: { only_integer: true }

  validate :date_cannot_be_in_the_past
  validate :hourly_rate_cannot_exceed_maximum_allowed
  validate :check_project_status

  private

  def date_cannot_be_in_the_past
    errors.add(:deadline, 'não pode estar no passado') if deadline && deadline <= Date.today
  end

  def check_project_status
    errors.add(:project_id, 'não está aberto') if project && project.open_until < Date.today
  end

  def hourly_rate_cannot_exceed_maximum_allowed
    if hourly_rate && project&.max_hourly_rate && hourly_rate > project.max_hourly_rate
      errors.add(:hourly_rate, 'não pode ser maior que o limite do projeto')
    end
  end
end
