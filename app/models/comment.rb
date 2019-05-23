class Comment < ApplicationRecord
  belongs_to :author, foreign_key: :user_id, class_name: 'User'
  belongs_to :commentable, polymorphic: true

  validates :body, :author, :commentable, presence: true

  delegate :name, to: :author, prefix: true
end
