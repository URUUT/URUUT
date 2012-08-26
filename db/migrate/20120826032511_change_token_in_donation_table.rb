class ChangeTokenInDonationTable < ActiveRecord::Migration
  def up
  	rename_column :donations, :token, :customer_token
  end

  def down
  end
end
