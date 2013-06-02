class AddWebsiteToProjectSponsors < ActiveRecord::Migration
  def change
    add_column :project_sponsors, :site, :string
  end
end
