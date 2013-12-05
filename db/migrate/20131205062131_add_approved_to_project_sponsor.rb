class AddApprovedToProjectSponsor < ActiveRecord::Migration
  def change
    add_column :project_sponsors, :approved, :boolean, :default => false
  end
end
