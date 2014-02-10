class DemoRequestMailer < ActionMailer::Base
  layout 'mailer'
  default from: "info@uruut.com"

  def scheduled_demo_confirmation(demo_request)
    @user = demo_request

    mail to: demo_request.email, bcc: "pbrobson@uruut.com, mfeinberg@uruut.com, bnorwood@uruut.com", subject: 'Scheduled Your URUUT Demo'
  end
end
