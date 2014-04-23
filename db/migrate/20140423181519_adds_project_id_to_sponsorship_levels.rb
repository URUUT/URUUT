class AddsProjectIdToSponsorshipLevels < ActiveRecord::Migration
  def change
    add_column :sponsorship_levels, :project_id, :integer
    add_index :sponsorship_levels, :project_id
  end
end
