class Question < ApplicationRecord
  has_many :answers, -> { order is_best: :desc, updated_at: :desc }
  has_one :best_answer, -> { where is_best: true }, class_name: 'Answer'
  has_many :attachments, as: :attachable, inverse_of: :attachable
  has_many :votes, as: :votable, inverse_of: :votable
  has_many :upvotes, -> { where value: 1 }, as: :votable, inverse_of: :votable, class_name: 'Vote'
  has_many :downvotes, -> { where value: -1 }, as: :votable, inverse_of: :votable, class_name: 'Vote'
  belongs_to :created_by, foreign_key: :created_by_id, class_name: 'User'

  accepts_nested_attributes_for :attachments, reject_if: :all_blank, allow_destroy: true

  validates :title, :body, :created_by, presence: true

  def set_best_answer(answer)
    raise ArgumentError unless answer.question == self

    if best_answer != answer
      transaction do
        best_answer&.unbest!
        answer.best!
      end
    end
  end

  def score
    votes.map(&:value).reduce 0, :+
  end
end
