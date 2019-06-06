# Preview all emails at http://localhost:3000/rails/mailers/question_mailer
class QuestionMailerPreview < ActionMailer::Preview
  # Preview this email at http://localhost:3000/rails/mailers/question_mailer/digest
  def digest
    user = User.first
    questions = Question.limit(10).all
    QuestionMailer.digest user, questions
  end

  # Preview this email at http://localhost:3000/rails/mailers/question_mailer/answer_added
  def answer_added
    user = User.first
    answer = Answer.first
    QuestionMailer.answer_added user, answer
  end
end
