FactoryBot.define do
  sequence(:email) { |n| "#{n}_#{Faker::Internet.email}" }
end
