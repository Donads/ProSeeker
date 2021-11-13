FactoryBot.define do
  factory :project_proposal, aliases: %i[proposal] do
    reason { 'Gosto muito de trabalhar com e-commerces e tenho experiência' }
    hourly_rate { 70.0 }
    weekly_hours { 30 }
    deadline { 2.months.from_now.to_date }
    status { :pending }
    association :user, :professional

    project

    trait :proposal_2 do
      reason { 'Domino o desenvolvimento de projetos web' }
      hourly_rate { 80.0 }
      weekly_hours { 40 }
    end

    trait :proposal_3 do
      reason { 'Sou especialista em e-commerces' }
      hourly_rate { 80.0 }
      weekly_hours { 50 }
    end

    trait :proposal_4 do
      reason { 'Sou especialista em atendimento presencial' }
      hourly_rate { 40.0 }
      weekly_hours { 20 }
    end

    trait :without_validations do
      to_create { |instance| instance.save(validate: false) }
    end
  end
end
