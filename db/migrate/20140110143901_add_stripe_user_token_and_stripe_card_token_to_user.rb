class AddStripeUserTokenAndStripeCardTokenToUser < ActiveRecord::Migration
  def change
    add_column :users, :stripe_user_token, :string
    add_column :users, :stripe_card_token, :string
  end
end
