class PressReleasesController < ApplicationController
  
  before_filter :authenticate_user!, :admin_required!
  
  def index
    @press_releases = PressRelease.all
  end
  
  def new
    @press_release = PressRelease.new
  end
  
  def edit
    @press_release = PressRelease.find(params[:id])
  end
  
  def create
    @press_release = PressRelease.new(params[:press_release])
    
    respond_to do |format|
      if @press_release.save
        format.html { redirect_to press_releases_path }
      end
    end
  end
  
  def update
  end
  
  def show
  end
  
  def destroy
    PressRelease.find(params[:id]).destroy
    flash[:success] = "Press Release Destroyed."
    redirect_to press_releases_url
  end
  
  private
  def admin_required!
    unless current_user.is_admin?
      flash[:error] = "Sorry, you don't have the right permissions to access this page."
      redirect_to root_url and return false
    end
  end
  
end
