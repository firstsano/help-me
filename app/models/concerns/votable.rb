module Votable
  extend ActiveSupport::Concern

  included do
    has_many :votes, as: :votable, inverse_of: :votable
    has_many :upvotes, -> { where value: 1 }, as: :votable, inverse_of: :votable, class_name: 'Vote'
    has_many :downvotes, -> { where value: -1 }, as: :votable, inverse_of: :votable, class_name: 'Vote'
  end

  def score
    votes.map(&:value).reduce 0, :+
  end

  def upvoted_by_user?(user)
    upvotes.find_by(user: user).present?
  end

  def downvoted_by_user?(user)
    downvotes.find_by(user: user).present?
  end
end
