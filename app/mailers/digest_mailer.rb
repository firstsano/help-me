class DigestMailer < ApplicationMailer
  def digest(user, questions)
    @questions = questions
    mail to: user.email, subject: 'Your digest for today'
  end
end
