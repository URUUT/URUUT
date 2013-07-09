class AddCustomerIdToProjectSponsors < ActiveRecord::Migration
  def change
    add_column :project_sponsors, :customer_id, :string
  end
end
