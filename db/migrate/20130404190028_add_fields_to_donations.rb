class AddFieldsToDonations < ActiveRecord::Migration
  def change
    add_column :donations, :user_id, :integer
    add_column :donations, :project_id, :integer
    add_column :donations, :amount, :float
    add_column :donations, :customer_token, :string
    add_column :donations, :email, :string
  end
end
