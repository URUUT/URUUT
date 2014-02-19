class ProjectAdmin::XlsController < ApplicationController
  before_filter :set_project, :admin_required!

  def create
    xls = XlsService.new(@project).create

    send_file xls.file_path
  end

private

  def set_project
    @project = Project.find(params[:project_id])
  end

  def admin_required!
    current_user.role == "admin" || @project.user.id.eql?(current_user.id)
  end

end
