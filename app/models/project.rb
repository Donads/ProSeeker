class Project < ApplicationRecord
  belongs_to :user
  has_many :project_proposals

  enum status: { open: 10, closed: 20, finished: 30 },
       attendance_type: { mixed_attendance: 10, remote_attendance: 20, presential_attendance: 30 }

  validates :title, :description, :skills, :max_hourly_rate, :open_until, :attendance_type, presence: true

  validates :max_hourly_rate, numericality: { greater_than: 0 }

  validate :date_cannot_be_in_the_past

  def currently_open?
    open? && open_until >= Date.current
  end

  private

  def date_cannot_be_in_the_past
    errors.add(:open_until, 'não pode estar no passado') unless open_until && open_until >= Date.current
  end
end
