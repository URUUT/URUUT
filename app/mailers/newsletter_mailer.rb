class NewsletterMailer < ActionMailer::Base
  layout 'mailer'
  default from: "info@uruut.com"

  def newsletter_confirmation(newsletter)
    @user = newsletter

    mail to: @user.email, subject: 'Welcome to URUUT News!'
  end
end
