class ContactMailerPreview
  def contact_confirmation
    ContactMailer.contact_confirmation name, email, subject, message
  end

end
