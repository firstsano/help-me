FactoryBot.define do
  factory :comment do
    body { Faker::Lorem.sentence }
    author
  end

  factory :question_comment do
    association :commentable, factory: :question
  end

  factory :answer_comment do
    association :commentable, factory: :answer
  end
end
