class WelcomeMailer < ActionMailer::Base
  layout 'mailer'
  default from: "info@uruut.com"

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.contact_mailer.contact_confirmation.subject
  #
  def welcome_confirmation_donor(user)
    if Rails.env.development?
      bcc = "alejo+bcc@bandofcoders.com, cbartels@uruut.com"
    else
      bcc = "welcome-donor@uruut.com"
    end

    @name = "#{user.first_name}" + " #{user.last_name}"
    @email = user.email
    @host = ActionMailer::Base.default_url_options[:host]
    unless @email.empty?
      mail to: @email, bcc: bcc,subject: "Welcome To URUUT"
    end
  end

  def welcome_confirmation_user(user)
    if Rails.env.development?
      bcc = "alejo+bcc@bandofcoders.com, cbartels@uruut.com"
    else
      bcc = "welcome-user@uruut.com"
    end

    @name = "#{user.first_name}" + " #{user.last_name}"
    @email = user.email
    @host = ActionMailer::Base.default_url_options[:host]
    unless @email.empty?
      mail to: @email, bcc: bcc, subject: "Welcome To URUUT"
    end
  end
end
