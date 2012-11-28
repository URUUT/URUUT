class CreatePerks < ActiveRecord::Migration
  def change
    create_table :perk do |t|
      t.string :name
      t.float :amount
      t.string :description

      t.timestamps
    end
  end
end
