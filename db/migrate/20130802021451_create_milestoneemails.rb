class CreateMilestoneemails < ActiveRecord::Migration
  def change
    create_table :milestoneemails do |t|
      t.boolean :fifteen_percent
      t.boolean :fifty_percent
      t.boolean :seventy_five_percent
      t.boolean :ninety_percent
      t.integer :project_id

      t.timestamps
    end
  end
end
