FactoryBot.define do
  factory :knowledge_field do
    title { 'Desenvolvedor' }

    trait :numbered do
      sequence(:title) { |n| "Área de Conhecimento #{n}" }
    end
  end
end
