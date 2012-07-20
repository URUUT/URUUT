class CreateProjects < ActiveRecord::Migration
  def change
    create_table :projects do |t|
      t.string :name
      t.integer :amount
      t.datetime :due_date

      t.timestamps
    end
  end
end
