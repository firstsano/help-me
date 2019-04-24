FactoryBot.define do
  factory :user, aliases: [:author] do
    sequence(:email) { |n| "#{n}_#{Faker::Internet.email}" }
    name { Faker::Name.name_with_middle }
    password { Faker::Internet.password }
    confirmed_at { Date.strptime '21-12-2000' }
  end
end
