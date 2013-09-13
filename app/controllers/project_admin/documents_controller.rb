class ProjectAdmin::DocumentsController < ApplicationController
  before_filter :set_project, except: :destroy

  def index
    @authenticated = admin_required!
    @documents = @project.documents.page(params[:page]).per(9) if @authenticated
  end

  def create
    @document = Document.create(filename: params[:filename], url: params[:url],  project_id: @project.id)
  end

  def destroy
    Document.delete(params[:id])
    render :text => "Success"
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
