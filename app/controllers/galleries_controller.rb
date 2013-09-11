class GalleriesController < ApplicationController
  def save_image
    @project = Project.find_by_id(session[:current_project])
    @image = @project.galleries.create({gallery_file_name: params[:gallery]})
    render json: { image_id: @image.id }
  end

  def destroy
    @image = Gallery.find(params[:id])
    @image.destroy

    render json: { image_id: @image.id }
  end

  def save_photo_tw_room
    project = Project.find(params[:project_id])
    @image = project.galleries.create(gallery_file_name: params[:file_url], gallery_type: "transparency_workroom")

    render json: { image_id: @image.id }
  end

end
