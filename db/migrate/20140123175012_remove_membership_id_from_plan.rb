class RemoveMembershipIdFromPlan < ActiveRecord::Migration
  def up
    remove_column :plans, :membership_id
  end

  def down
    add_column :plans, :membership_id, :integer
    add_index  :plans, :membership_id
  end
end
