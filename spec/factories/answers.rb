FactoryBot.define do
  factory :answer do
    body { Faker::Lorem.paragraph }
    question
    association :created_by, factory: :user
    is_best { false }

    trait :best do
      is_best { true }
    end
  end
end
