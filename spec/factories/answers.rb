FactoryBot.define do
  factory :answer do
    title { Faker::Lorem.word }
    body { Faker::Lorem.paragraph }
    question
    association :created_by, factory: :user
  end
end
