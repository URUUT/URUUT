class ProjectAdmin::ProjectsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :set_project, except: [:index, :update, :show]

  respond_to :js, except: [:index, :update, :show]
  layout false, :only => "stripe_update"

	def index
		@projects = Project.find(params[:id])
  end
  
  def show
    @project = Project.find(params[:id])
    @donations = Donation.find_all_by_project_id(@project.id)
    sponsors = ProjectSponsor.find_by_project_id(@project.id)
    @sponsor_count = sponsors.nil? ? 0 : sponsors.count
<<<<<<< HEAD
    logger.debug(@sponsor_count)
    logger.debug(@project)
    logger.debug(@donations)
  end

end
=======
  end

  def update
    asd
  end

  def message; end

  def overview; end

  def manage; end

  private

  def set_project
    @project = Project.find(params[:project_id])
  end

end
>>>>>>> 76c236a... add tab page function
