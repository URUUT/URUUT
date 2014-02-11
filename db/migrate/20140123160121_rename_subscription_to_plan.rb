class RenameSubscriptionToPlan < ActiveRecord::Migration
  def up
    rename_table :subscriptions, :plans
  end

  def down
    rename_table :plans, :subscriptions
  end
end
