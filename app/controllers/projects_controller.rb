class ProjectsController < ApplicationController
	def new
		@projects = Project.new
	end

	def create
		@project = Project.new(params[:project])

		@project.save
	end
end
