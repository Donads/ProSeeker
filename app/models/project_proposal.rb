class ProjectProposal < ApplicationRecord
  belongs_to :project
  belongs_to :user
  has_many :feedbacks

  enum status: { pending: 10, approved: 20, rejected: 30, rated: 40, canceled: 90 }

  before_validation :change_status_date, on: %i[create update]

  validates :reason, :hourly_rate, :weekly_hours, :deadline, :status, presence: true
  validates :status_reason, presence: true, on: %i[cancel reject]
  validates :hourly_rate, :weekly_hours, numericality: { greater_than: 0 }
  validates :weekly_hours, numericality: { only_integer: true }

  validate :deadline_cannot_be_in_the_past
  validate :deadline_must_be_within_limit
  validate :hourly_rate_cannot_exceed_maximum_allowed
  validate :check_project_status
  validate :can_not_be_canceled, on: %i[destroy]
  validate :proposal_must_be_unique_for_each_project, on: %i[create]

  def can_be_canceled?
    case status
    when 'approved'
      status_date >= Time.current - 3.days
    when 'rated'
      false
    when 'canceled'
      false
    when 'pending'
      true
    when 'rejected'
      true
    end
  end

  def creator?(user_param)
    user == user_param
  end

  private

  def change_status_date
    self.status_date = Time.current
  end

  def deadline_cannot_be_in_the_past
    errors.add(:deadline, 'não pode estar no passado') if deadline && deadline <= Date.current
  end

  def deadline_must_be_within_limit
    errors.add(:deadline, 'não pode passar de um ano') unless deadline && deadline <= 1.year.from_now
  end

  def check_project_status
    return if rated? && project&.finished?

    errors.add(:project_id, 'não está aberto') if project && (project.open_until < Date.current || !project.open?)
  end

  def hourly_rate_cannot_exceed_maximum_allowed
    return unless hourly_rate && project&.max_hourly_rate && hourly_rate > project.max_hourly_rate

    errors.add(:hourly_rate, 'não pode ser maior que o limite do projeto')
  end

  def can_not_be_canceled
    errors.add(:status, 'da proposta não permite cancelamento') unless can_be_canceled?
  end

  def proposal_must_be_unique_for_each_project
    return unless ProjectProposal.find_by(project: project, user: user)

    errors.add(:base, 'Proposta já existe pra esse projeto')
  end
end
