class CreateProjectSponsors < ActiveRecord::Migration
  def change
    create_table :project_sponsors do |t|
      t.string :name
      t.string :logo
      t.string :mission
      t.integer :cost
      t.string :card_token
      t.integer :project_id

      t.timestamps
    end
  end
end
