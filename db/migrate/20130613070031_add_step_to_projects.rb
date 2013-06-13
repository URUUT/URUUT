class AddStepToProjects < ActiveRecord::Migration
  def change
    add_column :projects, :step, :string
  end
end
