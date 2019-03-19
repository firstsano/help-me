class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :created_by, foreign_key: :created_by_id, class_name: 'User'
  has_many :attachments, as: :attachable, inverse_of: :attachable
  has_many :votes, as: :votable, inverse_of: :votable
  has_many :upvotes, -> { where value: 1 }, as: :votable, inverse_of: :votable, class_name: 'Vote'
  has_many :downvotes, -> { where value: -1 }, as: :votable, inverse_of: :votable, class_name: 'Vote'

  accepts_nested_attributes_for :attachments, reject_if: :all_blank, allow_destroy: true

  validates :body, :question, :created_by, presence: true

  def self.best
    where is_best: true
  end

  def best!
    update_attributes is_best: true
  end

  def unbest!
    update_attributes is_best: false
  end

  def can_be_best_for?(user)
    (not is_best?) and question.created_by == user
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
