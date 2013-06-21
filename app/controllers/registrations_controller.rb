class RegistrationsController < Devise::RegistrationsController
  def update
    @user = User.find(current_user.id)
    email_changed = @user.email != params[:user][:email]
    password_changed = !params[:user][:password].empty?

    successfully_updated = @user.update_attributes(params[:user])

    if successfully_updated
      # Sign in the user bypassing validation in case his password changed
      sign_in @user, :bypass => true
      # if params[:user][:avatar]
#         render json: { :path => (@user.errors.empty? ? @user.avatar : "#failed#") }
#       else
        redirect_to @user
      # end
    else
      render "edit"
    end
  end

  def after_sign_up_path_for(resource)
    begin
      sign_up_url = url_for(:action => 'create', :controller => 'registrations', :only_path => false, :protocol => 'http')
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
      elsif request.referer == sign_up_url
        super
      else
        stored_location_for(resource) || request.referer || root_path ||  request.env['omniauth.origin']
      end
      # logger.debug(request.referrer)
      # return root_url
    rescue
      super
    end
  end

end
