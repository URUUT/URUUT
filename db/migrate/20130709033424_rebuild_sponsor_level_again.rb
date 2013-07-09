class RebuildSponsorLevelAgain < ActiveRecord::Migration
  def change
    drop_table :sponsorship_levels
    create_table :sponsorship_levels do |t|
      t.string :name
      t.float :cost
      t.text :description
      t.integer :required
      t.integer :funding_goal

      t.timestamps
    end
    SponsorshipLevel.create([{id: 1, name: "Platinum"}, {id: 2, name: "Gold"}, {id: 3, name: "Silver"}, {id: 4, name: "Bronze"}])
  end
end
