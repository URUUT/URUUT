class PressCoveragesController < ApplicationController
  before_filter :authenticate_user!, :admin_required!
  
  def index
    @press_coverages = PressCoverage.all
  end
  
  def new
    @press_coverage = PressCoverage.new
  end
  
  def edit
    @press_coverage = PressCoverage.find(params[:id])
  end
  
  def create
    @press_coverage = PressCoverage.new(params[:press_coverage])
    
    respond_to do |format|
      if @press_coverage.save
        format.html { redirect_to press_coverages_path }
      end
    end
  end
  
  def update
  end
  
  def show
  end
  
  def destroy
    PressCoverage.find(params[:id]).destroy
    flash[:success] = "Press Release Destroyed."
    redirect_to press_coverages_url
  end
  
  private
  def admin_required!
    unless current_user.is_admin?
      flash[:error] = "Sorry, you don't have the right permissions to access this page."
      redirect_to root_url and return false
    end
  end
end
