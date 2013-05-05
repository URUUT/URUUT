class RegistrationsController < Devise::RegistrationsController
  def update
    @user = User.find(current_user.id)
    email_changed = @user.email != params[:user][:email]
    password_changed = !params[:user][:password].empty?

    successfully_updated = @user.update_attributes(params[:user])

    if successfully_updated
      # Sign in the user bypassing validation in case his password changed
      sign_in @user, :bypass => true
      if params[:user][:avatar]
        render json: { :path => (@user.errors.empty? ? @user.avatar_url : "#failed#") }
      else
        redirect_to @user
      end
    else
      render "edit"
    end
  end

end