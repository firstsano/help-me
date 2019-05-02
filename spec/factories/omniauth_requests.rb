FactoryBot.define do
  factory :omniauth_request do
    email { generate :email }
    uid { SecureRandom.uuid }
    name { Faker::Name.name }
    provider { Faker::Lorem.word }

    trait :overdue do
      confirmation_sent_at { DateTime.now - 2.years }
    end

    trait :confirmation_sent do
      confirmation_sent_at { DateTime.now - 2.hours }
    end

    trait :confirmed do
      confirmed_at { DateTime.now - 2.hours }
    end
  end
end
