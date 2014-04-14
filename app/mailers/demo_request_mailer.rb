class DemoRequestMailer < ActionMailer::Base
  layout 'mailer'
  default from: "info@uruut.com"

  def scheduled_demo_confirmation(demo_request)
    @user = demo_request

    mail to: demo_request.email, bcc: "charris@uruut.com, mfeinberg@uruut.com, bnorwood@uruut.com, alejo+bcc@bandofcoders.com", subject: 'Uruut - Schedule Your Demo?'
  end
end
