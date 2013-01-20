class AddFieldsToProject < ActiveRecord::Migration
  def change
    add_column :projects, :website, :string
    add_column :projects, :facebook_page, :string
    add_column :projects, :twitter_handle, :string
  end
end
