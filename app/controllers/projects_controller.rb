class ProjectsController < ApplicationController
	def new
		@projects = Project.new

	end

	def create
		@project = Project.new(params[:project])

		@project.save
	end

	def index
		@projects = Project.all
		respond_to do |format|
			format.html
		end
	end
end
