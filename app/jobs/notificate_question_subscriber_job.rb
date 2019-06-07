class NotificateQuestionSubscriberJob < ApplicationJob
  queue_as :default

  def perform(answer)
    subscribers = answer.question.subscribers - [answer.created_by]
    subscribers.each do |subscriber|
      QuestionMailer.answer_added(subscriber, answer).deliver_later
    end
  end
end
