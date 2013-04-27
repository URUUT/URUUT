class CreateProjectSponsor < ActiveRecord::Migration
  def change
    create_table :project_sponsors do |t|
      t.string :card_token
      t.float :cost
      t.text :logo
      t.text :mission
      t.string :name
      t.integer :project_id
      t.integer :sponsor_id
    end
  end
end
