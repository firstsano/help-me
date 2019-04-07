FactoryBot.define do
  factory :comment do
    body { Faker::Lorem.sentence }
    author
  end

  factory :question_comment do
    association :commentable, factory: :question
  end
end
