class AddPerkNameToDonations < ActiveRecord::Migration
  def change
    add_column :donations, :perk_name, :string
  end
end
