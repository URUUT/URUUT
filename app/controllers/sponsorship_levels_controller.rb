class SponsorshipLevelsController < ApplicationController
  def update
    # Creating custom levels
    project = Project.find(params[:id])
    new_levels = SponsorshipLevel.create_custom(project, params[:level], params)
    respond_to do |format|
      format.json { render :json => new_levels }
    end
  end
end
