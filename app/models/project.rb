class Project < ApplicationRecord
  validates :title, :description, :skills, :max_hourly_rate, :open_until, :attendance_type, presence: true

  validates :max_hourly_rate, numericality: { greater_than: 0 }

  validates :attendance_type,
            inclusion: { in: %w[Presencial Remoto Ambos],
                         message: "Tipos permitidos: 'Presencial', 'Remoto' ou 'Ambos'" }
end
