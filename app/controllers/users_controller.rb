class UsersController < ApplicationController
  skip_before_filter :set_previous_page

  def show
    @user = User.find(params[:id])
    @is_current = @user == current_user

    @projects_created = @user.projects.live.page(params[:page]).per(2)
    @projects_funded = @user.projects_funded.live.page(params[:page]).per(2)
  end

  def profile
    # @projects = Project.where("user_id = ?", current_user.id).page(params[:page]).per(2)
    @projects_created = current_user.projects.page(params[:page]).per(2)
    @projects_funded = current_user.projects_funded.page(params[:page]).per(2)
  end
end
