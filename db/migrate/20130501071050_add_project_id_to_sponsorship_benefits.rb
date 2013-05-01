class AddProjectIdToSponsorshipBenefits < ActiveRecord::Migration
  def change
    add_column :sponsorship_benefits, :project_id, :integer
  end
end
