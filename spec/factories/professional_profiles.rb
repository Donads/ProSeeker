FactoryBot.define do
  factory :professional_profile, aliases: %i[profile profile_1] do
    full_name { 'Fulano de Tal' }
    social_name { 'Ciclano da Silva' }
    description { 'Busco projetos desafiadores' }
    professional_qualification { 'Ensino Superior' }
    professional_experience { '6 anos trabalhando em projetos diversos' }
    birth_date { 30.years.ago.to_date }

    association :user, :professional
    association :knowledge_field, :numbered

    profile_photo do
      Rack::Test::UploadedFile.new(
        File.join("#{::Rails.root}/spec/fixtures", 'files/avatar_placeholder.png'), 'image/png'
      )
    end

    trait :profile_2 do
      full_name { 'George Washington' }
      social_name { 'Antonio Nunes' }
      description { 'Desenvolvedor com anos de experiência' }
      professional_qualification { 'Ensino Superior' }
      professional_experience { '15 anos trabalhando em projetos diversos' }
    end

    trait :profile_3 do
      full_name { 'Maria Eduarda' }
      social_name { 'Maria Eduarda' }
      description { 'Desenvolvedora experiente' }
      professional_qualification { 'Doutorado' }
      professional_experience { '10 anos trabalhando em projetos diversos' }
    end
  end
end
