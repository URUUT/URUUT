class ProjectMailer < ActionMailer::Base
  layout 'mailer'
  default from: "info@uruut.com"

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.contact_mailer.contact_confirmation.subject
  #
  def project_confirmation(project)
    if Rails.env.development?
      bcc = "alejo+bcc@bandofcoders.com, cbartels@uruut.com"
    else
      bcc = "project-confirmation@uruut.com"
    end

    user = User.find_by_id(project.user_id)

    @name = "#{user.first_name}" + " #{user.last_name}"
    @email = user.email
    @image = project.large_image
    @host = ActionMailer::Base.default_url_options[:host]
    @project = project
    @project_title = project.project_title

    mail to: @email, bcc: bcc, subject: "Wait For Approval"
  end

  def project_message(recepient, subject_email, header_image, content, project)
    @image = header_image
    @host = ActionMailer::Base.default_url_options[:host]
    @content = ApplicationController.helpers.simple_format(content)
    mail from: project.user.email, to: recepient, subject: subject_email
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
