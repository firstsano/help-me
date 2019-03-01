class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :created_by, foreign_key: :created_by_id, class_name: 'User'

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

  def best?
    is_best?
  end
end
