class ApplicationController < ActionController::Base
  protect_from_forgery
  layout :layout_by_resource

  def after_sign_in_path_for(resource)
    begin
      sign_in_url = url_for(:action => 'new', :controller => 'sessions', :only_path => false, :protocol => 'http')
      if session[:path] == "project_new"
        project = Project.new
        project.user_id = resource.id
        project.save
        session[:path] == ""
        edit_project_path(project.id)
      elsif request.referer == sign_in_url
        root_url
      else
        stored_location_for(resource) || request.referer || root_path ||  request.env['omniauth.origin']
      end
      # return root_url
    rescue
      super
    end
  end

  protected

  def layout_by_resource
   "application"
  end

  def set_session_wizard
    session[:step] = nil
  end

end
