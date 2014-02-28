class ContactMailer < ActionMailer::Base
  layout 'mailer'
  def contact_confirmation(name, email, subject, message)
    @name = name
    @email = email
    @message = message
    @subject = subject
    mail subject: @subject, from: @email, to: "xchange@techbridge.org"
  end
end
