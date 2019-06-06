class Question < ApplicationRecord
  include Votable
  include Commentable

  has_many :answers, -> { order is_best: :desc, updated_at: :desc }
  has_one :best_answer, -> { where is_best: true }, class_name: 'Answer'
  has_many :attachments, as: :attachable, inverse_of: :attachable
  belongs_to :created_by, foreign_key: :created_by_id, class_name: 'User'
  has_many :subscribers, class_name: 'QuestionSubscription', dependent: :destroy

  scope :digest, -> { where("created_at >= ?", (DateTime.now - 1.day)) }

  accepts_nested_attributes_for :attachments, reject_if: :all_blank, allow_destroy: true

  validates :title, :body, :created_by, presence: true

  after_create :subscribe_user

  def set_best_answer(answer)
    raise ArgumentError unless answer.question == self

    if best_answer != answer
      transaction do
        best_answer&.unbest!
        answer.best!
      end
    end
  end

  private

  def subscribe_user
    created_by.subscribe self
  end
end
