FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "usuario#{n}@teste.com.br" }
    password { '123456' }
    role { :user }

    trait :professional do
      sequence(:email) { |n| "profissional#{n}@teste.com.br" }
      role { :professional }
    end

    trait :admin do
      sequence(:email) { |n| "admin#{n}@teste.com.br" }
    end
  end
end
