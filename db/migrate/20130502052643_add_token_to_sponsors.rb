class AddTokenToSponsors < ActiveRecord::Migration
  def change
    add_column :sponsors, :token, :string
  end
end
