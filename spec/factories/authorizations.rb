FactoryBot.define do
  factory :authorization do
    sequence(:provider) { |n| "#{Faker::Lorem.word}#{n}" }
    uid { SecureRandom.uuid }
    user
  end
end
