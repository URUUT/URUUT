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
    if params[:mimetype].eql?("image")
      @image = project.galleries.create(gallery_file_name: params[:file_url], gallery_type: "transparency_workroom")
      @thumbnail_url = @image.gallery_file_name + "/convert?fit=scale&height=216&width=216"
      @link_text = "Delete Photo"
    else
      video_data = video_data_by_link(params[:video_link])
      file_url = thumbnail = ""
      unless video_data.blank?
        file_url = video_data.player_url.gsub('&feature=youtube_gdata_player', '')
        thumbnail = video_data.thumbnails.detect {|video| video.height == 180 }.url
      end

      puts thumbnail
      @image = project.galleries.create(
        gallery_file_name: file_url,
        gallery_type: "transparency_workroom",
        gallery_content_type: "video",
        thumbnail_url: thumbnail
        )
      @thumbnail_url = @image.thumbnail_url
      @link_text = "Delete Video"
    end

    respond_to :js
  end

end
