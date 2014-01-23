class ApplicationController < ActionController::Base
  protect_from_forgery
  layout :layout_by_resource
  before_filter :last_url, :session_email_forgot_password, :additional_information

  rescue_from ActionController::RoutingError, with: :render404

  def after_sign_in_path_for(resource)
    if session[:redirect_url] == new_project_url
      User.set_redirect_path
    elsif session[:redirect_url] == user_registration_url || request.referer.nil? || request.referer.start_with?(edit_user_password_url) || session[:redirect_url] == root_url
      root_url
    else
      stored_location_for(resource) || request.referer || session[:redirect_url]  ||  request.env['omniauth.origin']
    end
  end

  def last_url
    url = request.url.split("/").last
    unless params[:controller].eql?("registrations")
      session[:redirect_url_last] = session[:redirect_url]
      session[:redirect_url] = request.url if !url.eql?("sign_in")
    end
  end

  def session_email_forgot_password
      session[:email_forgot_password] = params[:user][:email] if params[:user]
  end

  def additional_information
    @email_users = User.pluck :email
  end

  def video_data_by_link(link)
    youtube_client = YouTubeIt::Client.new
    youtube_client.video_by(link)
  end

  def not_found
    raise ActionController::RoutingError.new('Not Found')
  end

  def render404
    render :file => 'public/404.html', status: 404, layout: false
  end

  protected

  def layout_by_resource
    "application"
  end

  def set_session_wizard
    session[:step] = nil
  end

  def get_projects
    @user = User.find(params[:user_id])
    comparison = params[:status].eql?("Funding Active") ? ">" : "<"
    @projects_created = @user.projects.where("campaign_deadline #{comparison} ? AND live = 1", Time.now).order("updated_at DESC").page(params[:created_page]).per(2)
  end

end
