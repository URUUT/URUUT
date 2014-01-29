class AddPlanIdToMembership < ActiveRecord::Migration
  def change
    add_column :memberships, :plan_id, :integer
    add_index  :memberships, :plan_id
  end
end
