class ContactMailer < ActionMailer::Base
  default from: "info@uruut.com"

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.contact_mailer.contact_confirmation.subject
  #
  def contact_confirmation(user)
    @greeting = "Hi"

    @name = user.name
    @email = user.email
    @message = message

    mail to: @email, subject: "Welcome to URUUT"
  end
end
