class ApplicationController < ActionController::Base
  protect_from_forgery
  layout :layout_by_resource

  def after_sign_in_path_for(resource)
    logger.debug(request.referrer)
    return root_url
  end

  protected

  def layout_by_resource
   "application"
  end

  def set_session_wizard
    session[:step] = nil
  end

end
