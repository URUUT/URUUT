class CreateProjects < ActiveRecord::Migration
  def change
    create_table :projects do |t|
      t.string :title
      t.string :description
      t.string :location
      t.integer :duration
      t.integer :goal
      t.string :category

      t.timestamps
    end
  end
end
