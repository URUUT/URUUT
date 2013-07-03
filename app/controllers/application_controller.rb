class ApplicationController < ActionController::Base
  protect_from_forgery
  layout :layout_by_resource
  before_filter :last_url, :session_email_forgot_password

  def after_sign_in_path_for(resource)
    if session[:path] == "project_new"
      project = Project.new
      project.user_id = resource.id
      project.save
      session[:path] == ""
      edit_project_path(project.id)
    elsif request.referer.eql?(new_user_registration_url) || request.referer.nil?
      if session[:path] == "project_new"
        project = Project.new
        project.user_id = resource.id
        project.save
        session[:path] == ""
        edit_project_path(project.id)
      elsif session[:path] == "sponsor_new"
        new_project_sponsor_url
      elsif session[:path]
        session[:path]
      end
    elsif request.referer.start_with?(edit_user_password_url)
      root_url
    else
      stored_location_for(resource) || request.referer || root_path ||  request.env['omniauth.origin']
    end
      # return root_url
    # rescue
    #   super
    # end
    # sign_in_url = url_for(:action => 'new', :controller => 'sessions', :only_path => false, :protocol => 'http')
    # if request.referer == sign_in_url
    #   super
    # else
    #   stored_location_for(resource) || request.referer || root_path
    # end
  end

  def last_url
    url = request.url.split("/").last
    puts url
    session[:redirect_url_last] = session[:redirect_url]
    session[:redirect_url] = request.url if !url.eql?("sign_in")
    puts session[:redirect_url]
  end

  def session_email_forgot_password
    if params[:controller].eql?("devise/passwords") and params[:action].eql?("create")
      session[:email_forgot_password] = params[:user][:email] if params[:user][:email]
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
