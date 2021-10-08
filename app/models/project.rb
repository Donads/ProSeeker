class Project < ApplicationRecord
  enum attendance_type: { mixed_attendance: 0, remote_attendance: 1, presential_attendance: 2 }

  validates :title, :description, :skills, :max_hourly_rate, :open_until, :attendance_type, presence: true

  validates :max_hourly_rate, numericality: { greater_than: 0 }
end
