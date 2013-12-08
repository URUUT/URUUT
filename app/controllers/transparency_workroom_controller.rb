class TransparencyWorkroomController < ApplicationController
	layout "landing"

	def index
		@project = Project.find(params[:project_id])
		@documents = @project.documents.all
		@photo_vids = @project.galleries.media_transparent_room(params[:page])
	end

	def download_file
	  	require 'open-uri'
	  	document = Document.find(params[:document_id])
		url = document.url
		data = open(url).read
		send_data data, :disposition => 'attachment', :filename => document.filename
	end
end
