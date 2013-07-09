class AddDescriptionToDonations < ActiveRecord::Migration
  def change
    add_column :donations, :description, :text
  end
end
