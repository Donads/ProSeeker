FactoryBot.define do
  factory :feedback do
    score { 4 }
    sequence(:user_feedback) { |n| "Teste de avaliação do profissional #{n}" }
    feedback_source { :from_user }

    project_proposal do
      association :project_proposal, project: (association :project, status: :finished), status: :approved
    end

    feedback_creator { project_proposal.project.user }
    feedback_receiver { project_proposal.user }

    trait :from_professional do
      score { 3 }
      sequence(:user_feedback) { |n| "Teste de avaliação do usuário #{n}" }
      sequence(:project_feedback) { |n| "Teste de avaliação do projeto #{n}" }
      feedback_source { :from_professional }

      feedback_creator { project_proposal.user }
      feedback_receiver { project_proposal.project.user }
    end
  end
end
