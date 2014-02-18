class DemoRequestMailerPreview
  def scheduled_demo_confirmation
    DemoRequestMailer.scheduled_demo_confirmation demo_request
  end

end
