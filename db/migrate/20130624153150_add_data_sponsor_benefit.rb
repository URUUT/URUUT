class AddDataSponsorBenefit < ActiveRecord::Migration
  def up
    SponsorshipLevel.destroy_all
    SponsorshipLevel.create([{id: 1, name: "Platinum"}, {id: 2, name: "Gold"}, {id: 3, name: "Silver"}, {id: 4, name: "Bronze"}])
  end

  def down
    SponsorshipLevel.destroy_all
  end
end
