FactoryBot.define do
  factory :project do
    title { 'Projeto de E-commerce' }
    description { 'Desenvolver plataforma web' }
    skills { 'Ruby on Rails' }
    max_hourly_rate { 80 }
    open_until { 2.months.from_now.to_date }
    attendance_type { :remote_attendance }

    user

    trait :project_2 do
      title { 'Desenvolvimento no cliente' }
      description { 'Desenvolver customizações em sistema' }
      skills { 'Comunicação e regras de negócio' }
      max_hourly_rate { 100 }
      attendance_type { :presential_attendance }
    end
  end
end
