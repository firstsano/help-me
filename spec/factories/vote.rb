FactoryBot.define do
  factory :vote do
    value { 1 }
    user

    factory :downvote do
      value { -1 }
    end

    factory :answer_vote do
      association :votable, factory: :answer
    end

    factory :question_vote do
      association :votable, factory: :question
    end
  end
end
