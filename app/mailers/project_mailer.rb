class ProjectMailer < ActionMailer::Base
  default from: "info@uruut.com"

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.contact_mailer.contact_confirmation.subject
  #
  def project_confirmation(project)
    user = User.find_by_id(project.user_id)
    logger.debug(user)

    @name = "#{user.first_name}" + " #{user.last_name}"
    @email = user.email
    @image = project.large_image
    @host = ActionMailer::Base.default_url_options[:host]
    @project = project
    @project_title = project.project_title

    mail to: @email, bcc: "info@uruut.com, cbartels@uruut.com", subject: "Wait For Approval"
  end

  def project_message(recepient, subject_email, header_image, content)
    @image = header_image
    @host = ActionMailer::Base.default_url_options[:host]
    @content = content
    mail to: recepient, subject: subject_email
  end

  def project_approved(project)
    user = User.find_by_id(project.user_id)
    email = user.email
    @name = "#{user.first_name}" + " #{user.last_name}"
    @image = project.large_image
    @host = ActionMailer::Base.default_url_options[:host]
    @project_id = project.id
    attachments['URUUTGuidebookFinal.pdf'] = File.read("#{Rails.root}/public/data/URUUTGuidebookFinal.pdf")
    mail to: email, subject: "Your Project Has Been Approved"
  end
end
