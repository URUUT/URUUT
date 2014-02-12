class AddStripeSubscriptionIdToMembership < ActiveRecord::Migration
  def change
    add_column :memberships, :stripe_subscription_id, :string
  end
end
