class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :created_by, foreign_key: :created_by_id, class_name: 'User'

  validates :title, :body, :question, :created_by, presence: true
end
