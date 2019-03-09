class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :created_by, foreign_key: :created_by_id, class_name: 'User'
  has_many :attachments, as: :attachable

  accepts_nested_attributes_for :attachments

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
end
