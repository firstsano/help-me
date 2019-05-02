class ApplicationMailer < ActionMailer::Base
  default from: Rails.application.credentials.fetch(:admin_email)
  layout 'mailer'
end
