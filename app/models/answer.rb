class Answer < ApplicationRecord
  belongs_to :question
  validates :title, :body, :question, presence: true
end
