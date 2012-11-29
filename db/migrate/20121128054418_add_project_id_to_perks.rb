class AddProjectIdToPerks < ActiveRecord::Migration
  def change
    add_column :perks, :project_id, :integer
  end
end
