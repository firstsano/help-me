class OmniauthRequestMailer < ApplicationMailer
  def confirmation_instructions(email, token)
    @token = token
    mail to: email, subject: "Confirm your authorization"
  end
end
