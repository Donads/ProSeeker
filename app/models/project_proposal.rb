class ProjectProposal < ApplicationRecord
  belongs_to :project
  belongs_to :user
  has_many :feedbacks

  enum status: { pending: 10, approved: 20, rejected: 30, rated: 40 }

  before_validation :change_status_date, on: %i[create update pending! approved! rejected! rated!]
  # before_validation :change_status_date, on: %i[new]

  validates :reason, :hourly_rate, :weekly_hours, :deadline, :status, presence: true
  validates :hourly_rate, :weekly_hours, numericality: { greater_than: 0 }
  validates :weekly_hours, numericality: { only_integer: true }

  validate :date_cannot_be_in_the_past
  validate :hourly_rate_cannot_exceed_maximum_allowed
  validate :check_project_status
  validate :can_not_be_canceled, on: %i[destroy]

  def can_be_canceled?
    case status
    when 'approved'
      status_date >= Time.current - 3.days
    when 'rated'
      false
    else
      true
    end
  end

  private

  def change_status_date
    self.status_date = Time.current
  end

  def date_cannot_be_in_the_past
    errors.add(:deadline, 'não pode estar no passado') if deadline && deadline <= Date.current
  end

  def check_project_status
    return if rated? && project&.finished?

    errors.add(:project_id, 'não está aberto') if project && (project.open_until < Date.current || !project.open?)
  end

  def hourly_rate_cannot_exceed_maximum_allowed
    if hourly_rate && project&.max_hourly_rate && hourly_rate > project.max_hourly_rate
      errors.add(:hourly_rate, 'não pode ser maior que o limite do projeto')
    end
  end

  def can_not_be_canceled
    errors.add(:status, 'da proposta não permite cancelamento') unless can_be_canceled?
  end
end
