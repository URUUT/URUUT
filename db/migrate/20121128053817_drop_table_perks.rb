class DropTablePerks < ActiveRecord::Migration
  def up
    drop_table :perks
  end
end
