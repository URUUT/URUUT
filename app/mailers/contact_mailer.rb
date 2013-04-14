class ContactMailer < ActionMailer::Base
  default from: "info@uruut.com"
  default to: "cbartels@uruut.com"

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.contact_mailer.contact_confirmation.subject
  #
  def contact_confirmation(name, email, subject, message)
    mail subject: subject
  end
end
