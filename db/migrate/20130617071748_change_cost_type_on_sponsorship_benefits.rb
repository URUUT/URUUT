class ChangeCostTypeOnSponsorshipBenefits < ActiveRecord::Migration
  def up
    change_column :sponsorship_benefits, :cost, :float, default: 0
  end

  def down
    change_column :sponsorship_benefits, :cost, :integer, default: 0
  end
end
