class Answer < ApplicationRecord
  include Votable
  include Commentable

  belongs_to :question
  belongs_to :created_by, foreign_key: :created_by_id, class_name: 'User'
  has_many :attachments, as: :attachable, inverse_of: :attachable

  accepts_nested_attributes_for :attachments, reject_if: :all_blank, allow_destroy: true

  validates :body, :question, :created_by, presence: true

  after_commit :notificate_question_subscribers

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

  def notificate_question_subscribers
    NotificateQuestionSubscriberJob.perform_later self
  end
end
