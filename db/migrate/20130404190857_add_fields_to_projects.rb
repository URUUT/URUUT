class AddFieldsToProjects < ActiveRecord::Migration
  def change
    add_column :projects, :title, :string
    add_column :projects, :description, :text
    add_column :projects, :location, :string
    add_column :projects, :duration, :string
    add_column :projects, :goal, :string
    add_column :projects, :category, :string
    add_column :projects, :user_id, :integer
    add_column :projects, :deleted, :integer
    add_column :projects, :address, :string
    add_column :projects, :city, :string
    add_column :projects, :state, :string
    add_column :projects, :zip, :integer
    add_column :projects, :neighborhood, :string
    add_column :projects, :live, :integer
    add_column :projects, :short_description, :text
    add_column :projects, :bitly, :string
    add_column :projects, :project_token, :string
    add_column :projects, :status, :string
    add_column :projects, :website, :string
    add_column :projects, :facebook_page, :string
    add_column :projects, :twitter_handle, :string
    add_column :projects, :organization, :string
    add_column :projects, :large_image, :string
    add_column :projects, :story, :text
    add_column :projects, :about, :text
    add_column :projects, :approval_date, :string
    add_column :projects, :project_title, :string
  end
end
