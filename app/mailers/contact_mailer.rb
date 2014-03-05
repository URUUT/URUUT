class ContactMailer < ActionMailer::Base
  layout 'mailer'
  def contact_confirmation(name, email, subject, message)
    @name = name
    @email = email
    @message = message
    @host = ActionMailer::Base.default_url_options[:host]
    @subject = subject
    mail subject: @subject, from: @email, to: "xchange@techbridge.org"
  end
end
