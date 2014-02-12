class CreateSubscriptions < ActiveRecord::Migration
  def change
    create_table :subscriptions do |t|
      t.references :membership
      t.string     :stripe_plan_id

      t.timestamps
    end
    add_index :subscriptions, :membership_id
  end
end
