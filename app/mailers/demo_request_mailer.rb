class DemoRequestMailer < ActionMailer::Base
  layout 'mailer'
  default from: "info@uruut.com"

  def scheduled_demo_confirmation(demo_request)
    if Rails.env.development?
      bcc = "alejo+bcc@bandofcoders.com, cbartels@uruut.com"
    else
      bcc = "demo-request@uruut.com"
    end

    @user = demo_request

    mail to: demo_request.email, bcc: bcc, subject: 'Uruut - Schedule Your Demo?'
  end
end
