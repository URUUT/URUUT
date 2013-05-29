class AddCostToSponsorshipBenefits < ActiveRecord::Migration
  def change
    add_column :sponsorship_benefits, :cost, :integer
  end
end
