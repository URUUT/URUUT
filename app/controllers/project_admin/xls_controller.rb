class ProjectAdmin::XlsController < ApplicationController
  before_filter :set_project, :admin_required!
  before_filter :get_donors, :get_project_sponsors

  def create
    xls = XlsService.new(@donors, @project_sponsors).create

    send_file xls.file_path
  end

private

  def set_project
    @project = Project.find(params[:project_id])
  end

  def admin_required!
    current_user.role == "admin" || @project.user.id.eql?(current_user.id)
  end

  def get_donors
    @donors  = User.unique_project_donors(@project)
  end

  def get_project_sponsors
    @project_sponsors = @project.project_sponsors
  end

end
