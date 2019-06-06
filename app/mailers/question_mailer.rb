class QuestionMailer < ApplicationMailer
  def digest(user, questions)
    @questions = questions
    mail to: user.email, subject: 'Your digest for today'
  end

  def answer_added(user, answer)
    @answer = answer
    @question = answer.question
    mail to: user.email, subject: 'New answer to your question'
  end
end
