class AddCampaignDeadlineToProjects < ActiveRecord::Migration
  def change
    add_column :projects, :campaign_deadline, :datetime
    Project.update_all("campaign_deadline = '#{Time.now.tomorrow.to_date}'")
  end
end
