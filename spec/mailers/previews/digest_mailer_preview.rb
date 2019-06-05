# Preview all emails at http://localhost:3000/rails/mailers/digest_mailer
class DigestMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/digest_mailer/digest
  def digest
    DigestMailer.digest
  end

end
