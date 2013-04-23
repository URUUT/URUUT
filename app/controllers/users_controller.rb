class UsersController < ApplicationController
  skip_before_filter :set_previous_page
  
  def profile
    @projects = Project.where("user_id = ?", current_user.id).page(params[:page]).per(6)
  end
end
