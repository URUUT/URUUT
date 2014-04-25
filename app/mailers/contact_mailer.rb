class ContactMailer < ActionMailer::Base
  layout 'mailer'
  # default from: "info@uruut.com"
  # default to: "mfeinberg@uruut.com, bnorwood@uruut.com"

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.contact_mailer.contact_confirmation.subject
  #
  def contact_confirmation(name, email, subject, message)
    @name = name
    @email = email
    @message = message
    @subject = subject
    mail subject: @subject, from: @email, to: "contact-us@uruut.com"
  end
end
