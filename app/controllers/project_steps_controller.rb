class ProjectStepsController < ApplicationController
  include Wicked::Wizard
  steps :step1, :step2, :step3, :step4

  def show
    @project = Project.find_by_id(session[:current_project])
    logger.debug(@project)
    render_wizard
  end

  def update
    @project = Project.find_by_id(session[:current_project])
    @project.attributes = params[:project]
    render_wizard @project
  end
end
