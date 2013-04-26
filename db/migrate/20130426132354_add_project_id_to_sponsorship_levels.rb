class AddProjectIdToSponsorshipLevels < ActiveRecord::Migration
  def change
    add_column :sponsorship_levels, :project_id, :integer
  end
end
