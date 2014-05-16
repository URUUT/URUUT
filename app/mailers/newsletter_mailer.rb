class NewsletterMailer < ActionMailer::Base
  layout 'mailer'
  default from: "info@uruut.com"

  def newsletter_confirmation(newsletter)
    if Rails.env.development?
      bcc = "alejo+bcc@bandofcoders.com, cbartels@uruut.com"
    else
      bcc = "newsletter-confirm@uruut.com"
    end

    @user = newsletter

    mail to: @user.email, bcc: bcc, subject: 'Welcome to URUUT News!'
  end
end
