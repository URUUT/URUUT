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
    @project_title = project.title

    mail to: @email, subject: "Wait For Approval"
  end

  def project_message(recepient, header_image, content)
    @image = header_image
    @content = content
    mail to: recepient, subject: "Project messages from Crowfundproject"
  end

  def project_approved(project)
    user = User.find_by_id(project.user_id)
    email = user.email
    @name = "#{user.first_name}" + " #{user.last_name}"
    @host = ActionMailer::Base.default_url_options[:host]
    @project_id = project.id
    mail to: email, subject: "Your Project Has Been Approved"
  end
end
