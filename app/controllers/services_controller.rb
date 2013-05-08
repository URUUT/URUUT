class ServicesController < ApplicationController
  before_filter :authenticate_user!

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
          name = "#{auth.extra.raw_info.firstName} #{auth.extra.raw_info.lastName}"
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
            user = User.find_by_email(email)
            if user
              user.services.create(:provider => provider, :uid => uid)
              flash[:notice] = "Provider #{provider.capitalize} added to your account"
              sign_in_and_redirect(:user, user)
            else
              user = User.new(:email => email, :name => name)
              user.services.build(:provider => provider, :uid => uid)
              user.save

              if user.persisted?
                flash[:notice] = "Successfully registered via #{provider.capitalize}"
                sign_in_and_redirect(:user, user)
              else
                session["devise.user_attributes"] = user.attributes
                session["devise.provider"] = provider
                session["devise.uid"] = uid
                redirect_to new_user_registration_path
              end
            end
          end
        end
      end
    end
  end

  def destroy
    # Don't allow user to delete all linked accounts if he has not set password
    if current_user.services.count == 1 && current_user.encrypted_password.blank?
      flash[:error] = "Please set your profile password before deleting all social accounts"
    else
      @service = current_user.services.find(params[:id])
      @service.destroy
    end

    redirect_to services_path
  end
end
