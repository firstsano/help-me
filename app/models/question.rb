class Question < ApplicationRecord
  has_many :answers
  belongs_to :created_by, foreign_key: :created_by_id, class_name: 'User'

  validates :title, :body, :created_by, presence: true
end
