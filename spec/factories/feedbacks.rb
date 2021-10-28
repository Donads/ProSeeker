FactoryBot.define do
  factory :feedback do
    score { 3.0 }
    sequence(:user_feedback) { |n| "Teste de avaliação do profissional #{n}" }
    feedback_source { :from_user }

    feedback_creator { association :user }
    feedback_receiver { association :user, :professional }
    # project = association :project, status: :finished
    # project_proposal { association :project_proposal, project: project, status: :approved }
    project_proposal do
      association :project_proposal, project: (association :project, status: :finished), status: :approved
    end

    trait :from_professional do
      score { 3 }
      sequence(:user_feedback) { |n| "Teste de avaliação do usuário #{n}" }
      sequence(:project_feedback) { |n| "Teste de avaliação do projeto #{n}" }
      feedback_source { :from_professional }

      feedback_creator { association :user, :professional }
      feedback_receiver { association :user }
    end
  end
end
