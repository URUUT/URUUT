class AddSponsorIdToMembership < ActiveRecord::Migration
  def change
    add_column :memberships, :sponsor_id, :integer
    add_index :memberships, :sponsor_id
  end
end
