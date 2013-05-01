class ServicesController < ApplicationController
  def index
    @services = current_user.services.all
  end

  def create
    # Service parameter from routing and callbacks
    provider = (params[:provider] ? params[:provider] : "no provider")

    auth = request.env["omniauth.auth"]
    # Proceed if omniauth hash and provider name available
    if auth && params[:provider]
      case provider
        when "facebook"
          uid = auth.uid
          email = auth.info.email
          name = auth.extra.raw_info.name
        when "twitter"
          uid = auth.uid
          name = auth.info.name
        when "linkedin"
          uid = auth.uid
          email = auth.extra.raw_info.emailAddress
          name = "auth.extra.raw_info.firstName auth.extra.raw_info.lastName"
      end

      if uid.present? && provider.present?
        # If user signed in, add the service to account
        if user_signed_in?
          service = Service.find_by_provider_and_uid(provider, uid)
          if service.nil?
            current_user.services.create(:provider => provider, :uid => uid)
            flash[:notice] = "Service #{provider.capitalize} successfully added to your profile"
          else
            flash[:error] = "#{provider.capitalize} is already linked to your profile"
          end

          redirect_to services_path
        # If user not signed in
        else
          # Sign in or create a new service
          service = Service.find_by_provider_and_uid(provider, uid)
          if service
            flash[:notice] = "Successfully signed in via #{provider.capitalize}"
            sign_in_and_redirect(:user, service.user)
          else
            # TODO: Register w/o email (Twitter)
            if email.present?
              user = User.find_by_email(email)
              if user
                user.services.create(:provider => provider, :uid => uid)
                flash[:notice] = "Provider #{provider.capitalize} added to your account"
                sign_in_and_redirect(:user, service.user)
              else
                user = User.new(:email => email, :name => name)
                user.services.build(:provider => provider, :uid => uid)
                user.save!

                flash[:notice] = "Successfully registered via #{provider.capitalize}"
                sign_in_and_redirect(:user, user)
              end
            end
          end
        end
      end
    end

    #auth = request.env['omniauth.auth']
    ## Find an service here
    #@service = Service.find_with_omniauth(auth)
    #
    #if @service.nil?
    #  # If no service was found, create a brand new one here
    #  @service = Service.create_with_omniauth(auth)
    #end
    #
    #if signed_in?
    #  if @service.user_id == current_user
    #    # User is signed in so they are trying to link an service with their
    #    # account. But we found the service and the user associated with it
    #    # is the current user. So the service is already associated with
    #    # this user. So let's display an error message.
    #    logger.debug(1)
    #    redirect_to root_url, notice: "Already linked that account!"
    #  else
    #    # The service is not associated with the current_user so lets
    #    # associate the service
    #    @service.user_id = current_user
    #    @service.save()
    #    logger.debug(2)
    #    redirect_to root_url, notice: "Successfully linked that account!"
    #  end
    #else
    #  if @service.user_id.present?
    #    # The service we found had a user associated with it so let's
    #    # just log them in here
    #    self.current_user = @service.user_id
    #    logger.debug(4)
    #    redirect_to root_url, notice: "Signed in!"
    #  else
    #    # No user associated with the service so we need to create a new one
    #    logger.debug(4)
    #    redirect_to new_user_registration_url, notice: "Please finish registering"
    #  end
    #end
  end

  def destroy
    @service = current_user.services.find(params[:id])
    @service.destroy

    redirect_to services_path
  end
end
