FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "#{n}_#{Faker::Internet.email}" }
    name { Faker::Name.name_with_middle }
  end
end
