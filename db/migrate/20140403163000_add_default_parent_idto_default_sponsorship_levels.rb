class AddDefaultParentIdtoDefaultSponsorshipLevels < ActiveRecord::Migration
  def up
    levels = SponsorshipLevel.where(id: [1,2,3,4])
    levels.each_with_index do |level, index|
      level.parent_id = index + 1
      level.save!
    end
  end
end
