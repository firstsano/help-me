class QuestionSubscription < ApplicationRecord
  belongs_to :question
  belongs_to :user

  validates :question, :user, presence: true
end
