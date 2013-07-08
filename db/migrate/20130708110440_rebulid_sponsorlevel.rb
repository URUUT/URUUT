class RebulidSponsorlevel < ActiveRecord::Migration
  def change
    drop_table :sponsorship_levels
    create_table :sponsorship_levels do |t|
      t.string :name

      t.timestamps
    end
    SponsorshipLevel.create([{id: 1, name: "Platinum"}, {id: 2, name: "Gold"}, {id: 3, name: "Silver"}, {id: 4, name: "Bronze"}])
  end
end
