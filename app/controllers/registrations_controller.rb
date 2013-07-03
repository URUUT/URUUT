class RegistrationsController < Devise::RegistrationsController
  def update
    @user = User.find(current_user.id)
    email_changed = @user.email != params[:user][:email]
    password_changed = !params[:user][:password].empty?

    successfully_updated = @user.update_attributes(params[:user])
    session[:avatar] = params[:user][:avatar]
    if successfully_updated
      # Sign in the user bypassing validation in case his password changed

      sign_in @user, :bypass => true
      # if params[:user][:avatar]
#         render json: { :path => (@user.errors.empty? ? @user.avatar : "#failed#") }
#       else
        session.delete(:avatar)
        redirect_to @user
      # end
    else
      session[:avatar] = params[:user][:avatar]
      render "edit"
    end
  end

  def after_sign_up_path_for(resource)
    # sign_up_url = url_for(:action => 'create', :controller => 'registrations', :only_path => false, :protocol => 'http')
    if session[:redirect_url_last] == new_project_url
      session.delete(:path)
      project = Project.new
      project.user_id = resource.id
      project.save
      "/projects/#{project.id}/edit#sponsor-info"
    elsif session[:redirect_url_last] == user_registration_url
      root_url
    else
      stored_location_for(resource) || request.referer || session[:redirect_url_last]  ||  request.env['omniauth.origin']
    end
      # logger.debug(request.referrer)
      # return root_url
  end

end
