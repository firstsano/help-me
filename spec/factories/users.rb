FactoryBot.define do
  factory :user, aliases: [:author] do
    email { generate :email }
    name { Faker::Name.name_with_middle }
    password { Faker::Internet.password }
    confirmed_at { DateTime.now - 2.hours }
  end
end
