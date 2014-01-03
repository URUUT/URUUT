class ProjectAdmin::XlsController < ApplicationController
  before_filter :set_project, :admin_required!

  def create
    funders = get_funders
    xls = XlsService.new(funders).create

    send_file xls.file_path
  end

private

  def set_project
    @project = Project.find(params[:project_id])
  end

  def admin_required!
    current_user.role == "admin" || @project.user.id.eql?(current_user.id)
  end

  def get_funders
    case params[:type]
    when 'sponsor'
      @project.project_sponsors
    else
      user_ids = @project.donations.select(:user_id).uniq
      User.where(id: user_ids)
    end
  end

end
