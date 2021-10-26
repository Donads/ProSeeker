class Project < ApplicationRecord
  belongs_to :user
  has_many :project_proposals

  enum status: { open: 10, closed: 20, finished: 30 },
       attendance_type: { mixed_attendance: 10, remote_attendance: 20, presential_attendance: 30 }

  validates :title, :description, :skills, :max_hourly_rate, :open_until, :attendance_type, presence: true

  validates :max_hourly_rate, numericality: { greater_than: 0 }

  validate :open_until_cannot_be_in_the_past
  validate :open_until_must_be_within_limit

  def creator?(user_param)
    user == user_param
  end

  def currently_open?
    open? && open_until >= Date.current
  end

  def feedback_from_professional(professional)
    Feedback.joins(:project_proposal).find_by(feedback_creator: professional, project_proposal: { project: self })
  end

  def self.search(search_term)
    search_term = "%#{search_term}%"
    Project.where('title LIKE :title OR description LIKE :description', title: search_term, description: search_term)
  end

  private

  def open_until_cannot_be_in_the_past
    errors.add(:open_until, 'não pode estar no passado') unless open_until && open_until >= Date.current
  end

  def open_until_must_be_within_limit
    errors.add(:open_until, 'não pode passar de um ano') unless open_until && open_until <= 1.year.from_now
  end
end
