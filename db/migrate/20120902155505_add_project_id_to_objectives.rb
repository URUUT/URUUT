class AddProjectIdToObjectives < ActiveRecord::Migration
  def change
    add_column :objectives, :project_id, :integer
  end
end
