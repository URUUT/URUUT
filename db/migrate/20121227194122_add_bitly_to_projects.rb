class AddBitlyToProjects < ActiveRecord::Migration
  def change
    add_column :projects, :bitly, :string
  end
end
