class ProjectStepsController < ApplicationController
  include Wicked::Wizard
  steps :step1, :step2, :step3, :step4

  # def edit
  #     @project = Project.find(params[:id])
  #     render_wizard
  #   end
  
  def show
    @project = Project.find_by_id(session[:current_project])
    logger.debug(@project)
    @project.perks.build
    @project.galleries.build
    render_wizard
  end

  def update
    @project = Project.find_by_id(session[:current_project])
    @project.attributes = params[:project]
    render_wizard @project
  end
end
