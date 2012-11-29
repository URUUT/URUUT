class CreatePerks < ActiveRecord::Migration
  def change
    create_table :perks do |t|
      t.string :name
      t.float :amount
      t.text :description

      t.timestamps
    end
  end
end
