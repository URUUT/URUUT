class ProjectStepsController < ApplicationController
  include Wicked::Wizard
  steps :step1, :step2, :step3, :step4

  def show
    @project = session[:current_project]
    logger.debug(@project)
    skip_step
  end

  def update
    @project = session[:current_project]
    @project.attributes = params[:project]
    render_wizard @project
  end
end
