class NewsletterMailer < ActionMailer::Base
  layout 'mailer'
  default from: "info@uruut.com"

  def newsletter_confirmation(newsletter)
    @user = newsletter

    mail to: @user.email, bcc: "charris@uruut.com, mfeinberg@uruut.com, bnorwood@uruut.com, alejo+bcc@bandofcoders.com", subject: 'Welcome to URUUT News!'
  end
end
