class TransparencyWorkroomController < ApplicationController
	layout "landing"

	def index
		@project = Project.find(params[:project_id])
		@documents = @project.documents.all
		@photo_vids = @project.galleries.media_transparent_room(params[:page])
	end

	def show
	end
end
