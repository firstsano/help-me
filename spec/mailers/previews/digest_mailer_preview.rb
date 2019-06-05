# Preview all emails at http://localhost:3000/rails/mailers/digest_mailer
class DigestMailerPreview < ActionMailer::Preview
  # Preview this email at http://localhost:3000/rails/mailers/digest_mailer/digest
  def digest
    user = User.first
    questions = Question.limit(10).all
    DigestMailer.digest user, questions
  end
end
