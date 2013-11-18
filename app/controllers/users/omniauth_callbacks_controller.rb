class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController

  def facebook
    # You need to implement the method below in your model (e.g. app/models/user.rb)
    @user = User.find_for_social_oauth(request.env["omniauth.auth"], current_user, "facebook")
    if @user.persisted?
      # sign_in_and_redirect @user, :event => :authentication #this will throw if @user is not activated
      sign_in(:user, @user)
      after_sign_in_modify
    else
      session["devise.facebook_data"] = request.env["omniauth.auth"]
      after_sign_in_modify
    end
  end

  def twitter
    # You need to implement the method below in your model (e.g. app/models/user.rb)
    @user = User.find_for_social_oauth(request.env["omniauth.auth"], current_user, "twitter")

    if @user.persisted?
      sign_in_and_redirect @user, :event => :authentication #this will throw if @user is not activated
      set_flash_message(:notice, :success, :kind => "Twitter") if is_navigational_format?
    else
      puts @user
      session["devise.twitter_data"] = request.env["omniauth.auth"]
      redirect_to new_user_registration_url
    end
  end

  def linkedin
    # You need to implement the method below in your model (e.g. app/models/user.rb)
    @user = User.find_for_social_oauth(request.env["omniauth.auth"], current_user, "linkedln")

    if @user.persisted?
      sign_in_and_redirect @user, :event => :authentication #this will throw if @user is not activated
      set_flash_message(:notice, :success, :kind => "LinkedIn") if is_navigational_format?
    else
      session["devise.linkedin_data"] = request.env["omniauth.auth"]
      # redirect_to new_user_registration_url
    end
  end

  private

  def after_sign_in_modify
    # sign_up_url = url_for(:action => 'new', :controller => 'registration', :only_path => false, :protocol => 'http')
    if session[:redirect_url_last] == new_project_url
      session.delete(:path)
      project = Project.new
      project.user_id = resource.id
      project.save!
      redirect_to "/projects/#{project.id}/edit#sponsor-info"
    elsif session[:redirect_url_last] == new_user_registration_url
      redirect_to root_url
    else
      redirect_to stored_location_for(resource) || session[:redirect_url_last] || request.referer ||  request.env['omniauth.origin']
    end
  end

end
