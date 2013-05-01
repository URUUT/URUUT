class ProjectAdmin::ProjectsController < ApplicationController
  before_filter :authenticate_user!

  layout false, :only => "stripe_update"

	def index
		@projects = Project.find_all_by_user_id(current_user.id)
  end

end