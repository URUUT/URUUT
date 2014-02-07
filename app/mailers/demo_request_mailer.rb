class DemoRequestMailer < ActionMailer::Base
  layout 'mailer'
  default from: "info@uruut.com"

  def scheduled_demo_confirmation(demo_request)
    @user = demo_request

    mail to: demo_request.email, subject: 'Scheduled Your URUUT Demo'
  end

  def whitepaper_demo_confirmation(demo_request)
    @user = demo_request
    mail to: demo_request.email, subject: 'Everything your  nonprofit needs to  reach more  donors  & raise more
funds.'
  end
end
