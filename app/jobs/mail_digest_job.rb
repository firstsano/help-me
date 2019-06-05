class MailDigestJob < ApplicationJob
  queue_as :default

  def perform
    questions = Question.digest
    users = User.all
    users.each { |user| DigestMailer.digest(user, questions).deliver_later }
  end
end
