class AddLevelIdAndStatusToProjectSponsors < ActiveRecord::Migration
  def change
    add_column :project_sponsors, :payment, :string, default: "Unpaid"
    add_column :project_sponsors, :status, :string, default: "Unconfirmed"
    add_column :project_sponsors, :level_id, :integer
  end
end
