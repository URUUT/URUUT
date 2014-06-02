class ProjectAdmin::ManualDonationsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :set_project

  respond_to :js, only: [:index]
  has_scope :page, :default => 1

  def index
    donations = @project.manual_donations
    @manual_donation = ManualDonation.new
    @manual_donations = Kaminari.paginate_array(donations).page(params[:page]).per(25)
  end

  def create
    manual_donation = ManualDonation.new(manual_donation_params)
    if manual_donation.save
      redirect_to project_admin_project_manual_donations_path(@project)
    else
      respond_to do |format|
        format.json { render json: manual_donation.errors, status: :unprocessable_entity }
      end
    end
  end

  private

  def set_project
    @project = Project.find(params[:project_id])
    admin_required!
  end

  def manual_donation_params
    param = params[:manual_donation]
    return param.merge({ project_id: @project.id }) if @project && param
    param
  end

  def admin_required!
    unless current_user.role == "admin" || @project.user.id.eql?(current_user.id)
      flash[:error] = "Sorry, you don't have right permision to accessing page."
      redirect_to root_url and return false
    end
  end

end
