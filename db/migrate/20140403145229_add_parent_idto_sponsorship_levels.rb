class AddParentIdtoSponsorshipLevels < ActiveRecord::Migration
  def up
    add_column :sponsorship_levels, :parent_id, :integer, index: true
  end

  def down
    remove_column :sponsorship_levels, :parent_id
  end
end
