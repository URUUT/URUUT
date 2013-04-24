class ApplicationController < ActionController::Base
  protect_from_forgery
  #before_filter :set_previous_page

  layout :layout_by_resource

  def after_sign_in_path_for(resource)
    logger.debug(request.referrer)
    return root_url
  end

  protected

  def layout_by_resource
    # if root_url
 #      "landing"
 #    else
      "application"
    # end
  end

  def set_previous_page
    session[:previous_page] = request.fullpath
    logger.debug "#{session[:previous_page]}"
  end

end
