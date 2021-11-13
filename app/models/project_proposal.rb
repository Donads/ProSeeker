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
  validates :user_id, uniqueness: {
    message: 'já possui proposta para esse projeto',
    scope: :project_id
  }

  validate :deadline_cannot_be_in_the_past
  validate :deadline_must_be_within_limit
  validate :hourly_rate_cannot_exceed_maximum_allowed
  validate :check_project_status
  validate :can_not_be_canceled, on: %i[destroy]

  def pending!
    return super if pending? || approved? || rejected?

    errors.add(:status, 'da proposta não permite essa alteração')
  end

  def approved!
    return super if pending? || approved?

    errors.add(:status, 'da proposta não permite essa alteração')
  end

  def rejected!
    return super if pending? || rejected?

    errors.add(:status, 'da proposta não permite essa alteração')
  end

  def rated!
    return super if approved? || rated?

    errors.add(:status, 'da proposta não permite essa alteração')
  end

  def canceled!
    return super if can_be_canceled? || canceled?

    errors.add(:status, 'da proposta não permite essa alteração')
  end

  def can_be_canceled?
    return status_date >= Time.current - 3.days if approved?

    pending? | rejected?
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
    return if can_be_canceled?

    errors.add(:status_date, 'da proposta não permite cancelamento')
    errors.add(:status, 'da proposta não permite cancelamento')
  end
end
