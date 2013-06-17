class AdminController < ApplicationController
  # http_basic_authenticate_with :name => "frodo", :password => "thering"
  before_filter :authenticate_user!, :admin_required!
  skip_before_filter :verify_authenticity_token
  layout :layout_by_resource

  def unapproved
    @unapproved_projects = Project.where(:ready_for_approval => 1)
    logger.debug(@unapproved_projects)
  end

  def approve
    data = params['approved']
    id = params['id']
    logger.debug(data)
    logger.debug(id)
    if data == "true"
      newData = "Success"
      project = Project.find_by_id(id)
      project.live = 1
      project.ready_for_approval = 0
      project.approval_date = Date.today
      project.save!
    else
      newData = "Failure"
    end
    respond_to do |format|
      format.js { render :json => newData.to_json }
    end
  end

  def layout_by_resource
    'admin'
  end

  private
  def admin_required!
    unless current_user.is_admin?
      flash[:error] = "Sorry, you don't have right permision to accessing page."
      redirect_to root_url and return false
    end
  end
end
