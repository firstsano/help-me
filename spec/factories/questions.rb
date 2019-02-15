FactoryBot.define do
  factory :question do
    title { Faker::Lorem.word }
    body { Faker::Lorem.paragraph }
    association :created_by, factory: :user
  end
end
