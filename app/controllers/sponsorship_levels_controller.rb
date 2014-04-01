class SponsorshipLevelsController < ApplicationController
  def update
    # Creating custom levels
    new_levels = create_custom_levels(params[:level])
    respond_to do |format|
      format.json { render :json => new_levels }
    end
  end

  private

  def create_custom_levels(new_levels)
    new_levels.map do |index, value|
      next if SponsorshipLevel::DEFAULT_NAMES[ value['name'].downcase ]
      level = SponsorshipLevel.new(value)
      level.save!
      level
    end
    new_levels.to_a.compact
  end
end