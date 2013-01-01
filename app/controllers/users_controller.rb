class UsersController < ApplicationController
  def profile
    @projects = Project.where("user_id = ?", current_user.id).page(params[:page]).per(6)
  end
end
