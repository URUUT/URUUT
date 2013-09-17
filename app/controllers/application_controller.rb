class ApplicationController < ActionController::Base
  protect_from_forgery
  layout :layout_by_resource
  before_filter :last_url, :session_email_forgot_password, :additional_information

  def after_sign_in_path_for(resource)
    if session[:redirect_url] == new_project_url
      session.delete(:path)
      project = Project.new
      project.user_id = resource.id
      project.save
      "/projects/#{project.id}/edit#sponsor-info"
    elsif session[:redirect_url] == user_registration_url || request.referer.nil? || request.referer.start_with?(edit_user_password_url) || session[:redirect_url] == root_url
      root_url
    else
      stored_location_for(resource) || request.referer || session[:redirect_url]  ||  request.env['omniauth.origin']
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
    unless params[:controller].eql?("registrations")
      session[:redirect_url_last] = session[:redirect_url]
      session[:redirect_url] = request.url if !url.eql?("sign_in")
    end
  end

  def session_email_forgot_password
    # if params[:controller].eql?("devise/passwords") and params[:action].eql?("create")
      session[:email_forgot_password] = params[:user][:email] if params[:user]
    # end
  end

  def additional_information
    @email_users = User.pluck :email
  end

  def video_data_by_link(link)
    youtube_client = YouTubeIt::Client.new
    youtube_client.video_by(link)
  end

  protected

  def layout_by_resource
    "application"
  end

  def set_session_wizard
    session[:step] = nil
  end
end
