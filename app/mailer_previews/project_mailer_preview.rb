class ProjectMailerPreview
  def project_confirmation
    ProjectMailer.project_confirmation project
  end


  def project_message
    ProjectMailer.project_message recepient, subject_email, header_image, content
  end


  def project_approved
    ProjectMailer.project_approved project
  end

end
