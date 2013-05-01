class RemoveColumnProjectIdInSponsorshipLevels < ActiveRecord::Migration
  def change
    remove_column :sponsorship_levels, :project_id
  end
end
