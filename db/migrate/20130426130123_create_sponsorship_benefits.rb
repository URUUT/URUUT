class CreateSponsorshipBenefits < ActiveRecord::Migration
  def change
    create_table :sponsorship_benefits do |t|
      t.string :name
      t.integer :sponsorship_level_id

      t.timestamps
    end
  end
end