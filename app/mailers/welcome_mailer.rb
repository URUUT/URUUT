class WelcomeMailer < ActionMailer::Base
  default from: "info@uruut.com"

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.contact_mailer.contact_confirmation.subject
  #
  def welcome_confirmation(user)
    logger.debug(user)

    @name = user.name
    @email = user.email
    unless @email.empty?
      mail to: @email, subject: "Welcome To URUUT"
    end
  end
end
