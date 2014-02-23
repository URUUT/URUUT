class QuestionMailerPreview
  def send_question
    QuestionMailer.send_question owner, name, email, subject, body
  end

end
