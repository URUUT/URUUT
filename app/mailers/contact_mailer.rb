class ContactMailer < ActionMailer::Base
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
    mail subject: subject, from: @email, to: "info@uruut.com"
  end
end
