class QuestionMailer < ActionMailer::Base
  layout 'mailer'

  def send_question(name, email, subject, body)
    @name = name
    @email = email
    @body = body
    @subject = subject
    mail subject: @subject, from: @email, to: "info@uruut.com"
  end
end
