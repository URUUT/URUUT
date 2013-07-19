class WelcomeMailer < ActionMailer::Base
  default from: "info@uruut.com"

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.contact_mailer.contact_confirmation.subject
  #
  def welcome_confirmation(user)
    logger.debug(user)

    @name = "#{user.first_name}" + " #{user.last_name}"
    @email = user.email
    @host = ActionMailer::Base.default_url_options[:host]
    unless @email.empty?
      mail to: @email, subject: "Welcome To URUUT"
    end
  end
end
