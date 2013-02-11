class ApplicationController < ActionController::Base
  protect_from_forgery
  # before_filter :set_previous_page

  layout :layout_by_resource

  def after_sign_in_path_for(resource)
    # logger.debug "#{session[:previous_page]}"
    return root_url
  end

  protected

  def layout_by_resource
    # if devise_controller?
    #      "login"
    #    else
      "application"
    # end
  end

  def set_previous_page
    session[:previous_page] = request.referrer
    logger.debug "#{session[:previous_page]}"
  end


end
