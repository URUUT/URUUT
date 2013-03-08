class ProjectStepsController < ApplicationController
  include Wicked::Wizard
  steps :step1, :step2, :step3, :step4

  def show
    @project = Project.find_by_id(session[:current_project])
    # @project.perks.build
    # @project.galleries.build
    logger.debug("Referrer is #{request.referer}")
    @step = step
    if request.referer == 'http://127.0.0.1:8080/projects/new' ||  request.referer == 'http://127.0.0.1:8080/projects' and step == :step1
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
