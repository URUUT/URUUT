class AdminController < ApplicationController
  http_basic_authenticate_with :name => "frodo", :password => "thering"
  layout :layout_by_resource
  
  def unapproved
    @unapproved_projects = Project.where("live = ?", 0)
  end
  
  # def create
 #  end
  
  def approve
    data = params['approved']
    id = params['id']
    logger.debug(data)
    logger.debug(id)
    if data == "true"
      newData = "Success"
      project = Project.find_by_id(id)
      project.live = 1
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
end
