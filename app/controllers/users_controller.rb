class UsersController < ApplicationController
  skip_before_filter :set_previous_page
  before_filter :authenticate_user!
  before_filter :check_user, only: :show

  def show
    @user = User.find(params[:id])
    @is_current = @user == current_user

    if params[:status].present?
      comparison = params[:status].eql?("Funding Active") ? ">" : "<"
      @projects_created = @user.projects.live.where("campaign_deadline #{comparison} ? AND live = 1", Time.now).order("updated_at DESC").page(params[:created_page]).per(2)
      @projects_funded = @user.projects_funded.where("campaign_deadline #{comparison} ? AND live = 1", Time.now).order("updated_at DESC").page(params[:funded_page]).per(2)
      @pending_projects = @user.projects.where(live: 0)
    else
      @projects_created = @user.projects.live.where("campaign_deadline > ?", DateTime.now).order("updated_at DESC").page(params[:created_page]).per(2)
      @projects_funded = @user.projects_funded.live.order("updated_at DESC").page(params[:funded_page]).per(2)
      @pending_projects = @user.projects.where(live: 0)
    end

    @projects_created.each do |p|
      puts p.title
    end
  end

  def profile
    @user = User.find(params[:user_id])
    # @pending_projects = @user.projects.where(live: 0)
    # @projects = Project.where("user_id = ?", current_user.id).page(params[:page]).per(2)
    if params[:status].present?
      comparison = params[:status].eql?("Funding Active") ? ">" : "<"
      @projects_created = @user.projects.live.where("campaign_deadline #{comparison} ? AND live = 1", Time.now).order("updated_at DESC").page(params[:created_page]).per(2)
      @projects_funded = @user.projects_funded.where("campaign_deadline #{comparison} ? AND live = 1", Time.now).order("updated_at DESC").page(params[:funded_page]).per(2)
    else
      @projects_created = @user.projects.live.order("updated_at DESC").page(params[:created_page]).per(2)
      @projects_funded = @user.projects_funded.live.order("updated_at DESC").page(params[:funded_page]).per(2)
    end
    # @projects_funded = current_user.projects_funded.page(params[:page]).per(2)
  end

  def get_complete_project
    @user = User.find(params[:user_id])
    comparison = params[:status].eql?("Funding Active") ? ">" : "<"
    @projects_funded = @user.projects_funded.where("campaign_deadline #{comparison} ? AND live = 1", Time.now).order("updated_at DESC").page(params[:created_page]).per(2)
  end

  private

  def check_user
    unless current_user.id.to_s.eql?(params[:id])
      flash[:error] = "Sorry, you don't have right permision to accessing page."
      redirect_to root_url and return false
    end
  end
end
