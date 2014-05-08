class SponsorshipLevelsController < ApplicationController
  def update
    # Creating custom levels
    project = Project.find(params[:id])
    new_levels = SponsorshipLevel.create_custom(project, levels, params)
    respond_to do |format|
      format.json { render :json => new_levels }
    end
  end

  private

  def levels
    return params[:level] if params[:level]
    SponsorshipLevel::DEFAULT_SPONSORSHIP_LEVEL_PARAM
  end
end
