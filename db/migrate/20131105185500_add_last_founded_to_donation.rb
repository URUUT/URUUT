class AddLastFoundedToDonation < ActiveRecord::Migration
  def change
    add_column :donations, :last_founded, :datetime
  end
end
