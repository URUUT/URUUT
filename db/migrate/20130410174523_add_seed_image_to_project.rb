class AddSeedImageToProject < ActiveRecord::Migration
  def change
    add_column :projects, :seed_image, :string
  end
end
