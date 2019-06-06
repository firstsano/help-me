class QuestionSubscription < ApplicationRecord
  belongs_to :question
  belongs_to :user

  validates :question, :user, presence: true
  validates :question_id, uniqueness: { scope: :user_id }
end
