class ContactMailer < ActionMailer::Base
  default from: "chad.bartels@gmail.com"

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.contact_mailer.contact_confirmation.subject
  #
  def contact_confirmation(name, email, message)
    @greeting = "Hi"

    @name = name
    @email = email
    @message = message

    mail to: "chad.bartels@gmail.com", subject: "Contact From Site"
  end
end
