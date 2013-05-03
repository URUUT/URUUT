class ProjectAdmin::ProjectsController < ApplicationController
  before_filter :authenticate_user!

  layout false, :only => "stripe_update"

	def index
		@projects = Project.find(params[:id])
  end

  def show
    @project = Project.find(params[:id])
    @donations = Donation.find_all_by_project_id(@project.id)
    # sponsors = ProjectSponsor.find_by_project_id(@project.id)
    sponsors = ProjectSponsor.where(@project.id)
    @sponsor_count = sponsors.nil? ? 0 : sponsors.count
    logger.debug(@sponsor_count)
    logger.debug(@project)
    logger.debug(@donations)
  end

end