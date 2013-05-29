class AddSponsorshipLevelToSponsorshipBenefits < ActiveRecord::Migration
  def change
    add_column :sponsorship_benefits, :sponsorship_level, :string
  end
end
