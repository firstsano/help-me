class Vote < ApplicationRecord
  belongs_to :votable, polymorphic: true
  belongs_to :user

  validates :votable, :user, presence: true
  validates :value, inclusion: [1, -1]
  validates :votable_id, uniqueness: { scope: [:user_id, :votable_type] }

  def upvote?
    value == 1
  end

  def downvote?
    value == -1
  end
end
