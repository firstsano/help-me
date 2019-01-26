FactoryBot.define do
  factory :answer do
    title { Faker::Lorem.word }
    body { Faker::Lorem.paragraph }
  end
end
