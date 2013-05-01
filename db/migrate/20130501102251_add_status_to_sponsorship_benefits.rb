class AddStatusToSponsorshipBenefits < ActiveRecord::Migration
  def change
    add_column :sponsorship_benefits, :status, :boolean, default: false
  end
end
