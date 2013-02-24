class ServicesController < ApplicationController
  def index
  end

  def create
    auth = request.env['omniauth.auth']
    # Find an service here
    @service = Service.find_with_omniauth(auth)

    if @service.nil?
      # If no service was found, create a brand new one here
      @service = Service.create_with_omniauth(auth)
    end

    if signed_in?
      if @service.user_id == current_user
        # User is signed in so they are trying to link an service with their
        # account. But we found the service and the user associated with it 
        # is the current user. So the service is already associated with 
        # this user. So let's display an error message.
        logger.debug(1)
        redirect_to root_url, notice: "Already linked that account!"
      else
        # The service is not associated with the current_user so lets 
        # associate the service
        @service.user_id = current_user
        @service.save()
        logger.debug(2)
        redirect_to root_url, notice: "Successfully linked that account!"
      end
    else
      if @service.user_id.present?
        # The service we found had a user associated with it so let's 
        # just log them in here
        self.current_user = @service.user_id
        logger.debug(4)
        redirect_to root_url, notice: "Signed in!"
      else
        # No user associated with the service so we need to create a new one
        logger.debug(4)
        redirect_to new_user_registration_url, notice: "Please finish registering"
      end
    end
  end

  def destroy
  end
end
