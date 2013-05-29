module DeviseHelper

  def devise_error_messages!
    unless resource.errors.full_messages.blank?
      "<div class='alert'>#{resource.errors.full_messages.map { |msg| content_tag(:div, msg) }.join}</div>".html_safe
    end
  end

  def forgot_password_messages!
    unless resource.errors.full_messages.blank?
      "<div class='alert'>We are sorry, that email address doesn't exist.
      Please login using a different address or #{link_to 'sign up', new_user_registration_path}</div>".html_safe
    end
  end

end
