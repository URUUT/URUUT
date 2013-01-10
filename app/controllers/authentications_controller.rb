class AuthenticationsController < ApplicationController
  def index
  end
  
  def create
    auth = request.env["omniauth.auth"]
    current_user.authentications.find_or_create_by_provider_and_uid(auth['provider'], auth['uid'])
    flash[:notice] = "Authentication successful."
    redirect_to authentications_url
  end
  
  def destroy
  end
end
