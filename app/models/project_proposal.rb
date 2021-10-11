class ProjectProposal < ApplicationRecord
  belongs_to :project
  belongs_to :user

  validates :reason, :hourly_rate, :weekly_hours, :deadline, presence: true
end
