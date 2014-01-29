class RegistrationsController < Devise::RegistrationsController

  layout "landing", only: [:confirmation]

  def edit
    @customer_card = Gateway::CardsService.new(current_user).find_card
  end

  def create
    build_resource

    if resource.save
      resource.build_membership.save
      Gateway::CustomerService.new(resource).create
      if resource.active_for_authentication?
        set_flash_message :notice, :signed_up if is_navigational_format?
        sign_up(resource_name, resource)
        respond_with resource, :location => after_sign_up_path_for(resource)
      else
        set_flash_message :notice, :"signed_up_but_#{resource.inactive_message}" if is_navigational_format?
        expire_session_data_after_sign_in!
        respond_with resource, :location => after_inactive_sign_up_path_for(resource)
      end
    else
      clean_up_passwords resource
      respond_with resource
    end
  end

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

  def step2
    @credit_card = CreditCard.new()
  end

  def after_sign_up_path_for(resource)
    # sign_up_url = url_for(:action => 'create', :controller => 'registrations', :only_path => false, :protocol => 'http')
    if session[:redirect_url] == new_project_url
      User.set_redirect_path
    elsif session[:path]
      session[:path]
    elsif session[:redirect_url] == user_registration_url
      root_url
    else
      stored_location_for(resource) || session[:redirect_url] || request.referer ||  request.env['omniauth.origin']
    end
      # logger.debug(request.referrer)
      # return root_url
  end

end
