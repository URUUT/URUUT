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
    new_levels.map do |default_name, value|
      new_name = value['name'].downcase
      next if SponsorshipLevel::DEFAULT_NAMES[ new_name ]
      level = SponsorshipLevel.new(value)
      level.parent_id = SponsorshipLevel::DEFAULT_NAMES[ default_name ]
      level.save!
      SponsorshipBenefit.modify_benefits_of_level(default_name, params[:id], level)
    end
    new_levels.to_a.compact
  end
end