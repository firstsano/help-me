FactoryBot.define do
  factory :authorization do
    provider { Faker::Lorem.word }
    uid { SecureRandom.uuid }
    user
  end
end
