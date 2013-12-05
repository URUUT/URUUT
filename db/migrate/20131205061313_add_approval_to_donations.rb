class AddApprovalToDonations < ActiveRecord::Migration
  def change
    add_column :donations, :approved, :boolean, :default => false
  end
end
