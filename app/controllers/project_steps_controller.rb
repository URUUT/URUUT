class ProjectStepsController < ApplicationController
  include Wicked::Wizard
  steps :step1, :step2, :step3, :step4
  
  def show
    @project = Project.find_by_id(session[:current_project])
    @project.perks.build
    @project.galleries.build
    @step = step
    if URI(request.referer).path == '/projects/new' ||  URI(request.referer).path == '/projects' and step == :step1
      redirect_to '/project_steps/step2'
    else
      render_wizard
    end
  end

  def update
    @project = Project.find_by_id(session[:current_project])
    @project.status = step
    @project.update_attributes!(params[:project])
    if @project.valid?
      logger.debug(@project.status)
      render_wizard @project, :notice => "You are on #{step}"
    else
      logger.debug("Not Valid")
    end
  end
end
