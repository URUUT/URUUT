class AddCouponStripeTokenUserTable < ActiveRecord::Migration
  def up
    add_column :users, :coupon_stripe_token, :string
  end

  def down
    remove_column :users, :coupon_stripe_token
  end
end
