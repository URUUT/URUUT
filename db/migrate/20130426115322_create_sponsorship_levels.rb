class CreateSponsorshipLevels < ActiveRecord::Migration
  def change
    create_table :sponsorship_levels do |t|
      t.string :name
      t.float :cost
      t.text :description
      t.integer :required
      t.integer :funding_goal

      t.timestamps
    end
  end
end
