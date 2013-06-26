class ApplicationController < ActionController::Base
  protect_from_forgery
  layout :layout_by_resource

  def after_sign_in_path_for(resource)
    begin
      sign_in_url = url_for(:action => 'new', :controller => 'sessions', :only_path => false, :protocol => 'http')
      puts sign_in_url
      puts request.referer
      if session[:path] == "project_new"
        project = Project.new
        project.user_id = resource.id
        project.save
        session[:path] == ""
        edit_project_path(project.id)
        puts "1"
      elsif request.referer == sign_in_url
        super
        puts "2"
      else
        stored_location_for(resource) || request.referer || root_path ||  request.env['omniauth.origin']
        puts "3"
      end
      # return root_url
    rescue
      puts "4"
      super
    end
    # sign_in_url = url_for(:action => 'new', :controller => 'sessions', :only_path => false, :protocol => 'http')
    # if request.referer == sign_in_url
    #   super
    # else
    #   stored_location_for(resource) || request.referer || root_path
    # end
  end

  protected

  def layout_by_resource
   "application"
  end

  def set_session_wizard
    session[:step] = nil
  end

end
