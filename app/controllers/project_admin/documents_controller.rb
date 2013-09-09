class ProjectAdmin::DocumentsController < ApplicationController
  before_filter :set_project

  def index
    @authenticated = admin_required!
    @documents = @project.documents if @authenticated
  end

  def create
    file_uploaded = Cloudinary::Uploader.upload(params[:url])
    @document = Document.create(filename: params[:filename], public_id: file_uploaded["public_id"], project_id: @project.id)
    render json: { document: @document }
  end

  def destroy
    @document = Document.find(params[:id])
    @document.destroy

    respond_to do |format|
      format.html { redirect_to project_admin_documents_url }
      format.json { head :no_content }
    end
  end

  private

  def set_project
    @project = Project.find(params[:project_id])
  end

  def admin_required!
   unless current_user.is_admin?
    @project.user.id.eql?(current_user.id) ? true : false
   end
 end

end
