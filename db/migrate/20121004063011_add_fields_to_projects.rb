class AddFieldsToProjects < ActiveRecord::Migration
  def change
    add_column :projects, :address, :string
    add_column :projects, :city, :string
    add_column :projects, :state, :string
    add_column :projects, :zip, :integer
    add_column :projects, :neighborhood, :string
  end
end
