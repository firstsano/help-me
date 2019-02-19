FactoryBot.define do
  factory :answer do
    body { Faker::Lorem.paragraph }
    question
    association :created_by, factory: :user
  end
end
