class Sponsors::RegistrationsController < Devise::RegistrationsController
  def update
    # required for settings form to submit when password is left blank
    if params[:sponsor][:password].blank?
      params[:sponsor].delete("password")
      params[:sponsor].delete("password_confirmation")
    end

    @sponsor = Sponsor.find(current_sponsor.id)
    if @sponsor.update_attributes(params[:sponsor])
      # Sign in the sponsor bypassing validation in case his password changed
      sign_in @sponsor, :bypass => true
      redirect_to root_path
    else
      render "edit"
    end
  end
end 
