class ProjectStepsController < ApplicationController
  include Wicked::Wizard
  steps :step1, :step2, :step3, :step4
  
  def show
    @project = Project.find_by_id(session[:current_project])
    logger.debug(step)
    logger.debug(URI(request.referer).path)
    logger.debug("current project is #{session[:current_project]}")
    @project.perks.build
    @project.galleries.build
    if URI(request.referer).path == '/projects/new' ||  URI(request.referer).path == '/projects' and step == :step1
      redirect_to '/project_steps/step2'
    else
      render_wizard
    end
  end

  def update
    @project = Project.find_by_id(session[:current_project])
    params[:project][:status] = step
    params[:project][:status] = 'active' if step == steps.last
    @project.attributes = params[:project]
    render_wizard @project
  end
end
