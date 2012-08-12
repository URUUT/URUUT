class AddVideoToProject < ActiveRecord::Migration
  def change
    add_column :projects, :video, :string
  end
end
