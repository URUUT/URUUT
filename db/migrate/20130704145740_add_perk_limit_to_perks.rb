class AddPerkLimitToPerks < ActiveRecord::Migration
  def change
    add_column :perks, :perk_limit, :integer
  end
end
