FactoryBot.define do
  factory :oauth_application, class: Doorkeeper::Application do
    name { Faker::Lorem.word }
    redirect_uri { "urn:ietf:wg:oauth:2.0:oob" }
    uid { SecureRandom.uuid }
    secret { SecureRandom.uuid }
  end
end
