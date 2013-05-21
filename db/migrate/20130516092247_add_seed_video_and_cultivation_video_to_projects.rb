class AddSeedVideoAndCultivationVideoToProjects < ActiveRecord::Migration
  def change
    add_column :projects, :seed_video, :string
    add_column :projects, :cultivation_video, :string
  end
end
