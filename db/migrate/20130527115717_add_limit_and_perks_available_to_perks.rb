class AddLimitAndPerksAvailableToPerks < ActiveRecord::Migration
  def change
    add_column :perks, :limit, :boolean, default: false
    add_column :perks, :perks_available, :string
  end
end
