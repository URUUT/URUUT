class QuestionMailer < ActionMailer::Base
  layout 'mailer'

  def send_question(owner, name, email, subject, body)
    @name  = name
    @email = email
    @body  = body
    @subject = subject
    @owner = owner
    mail subject: @subject, from: @email, to: @owner.email
  end
end
