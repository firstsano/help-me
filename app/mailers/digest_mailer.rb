class DigestMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.digest_mailer.digest.subject
  #
  def digest
    @greeting = "Hi"

    mail to: "to@example.org"
  end
end
