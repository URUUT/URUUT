class AddCardDetailsToProjectSponsors < ActiveRecord::Migration
  def change
    add_column :project_sponsors, :card_type, :string
    add_column :project_sponsors, :card_last4, :integer
  end
end
