class AddFieldsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :name, :string
    add_column :users, :website, :string
    add_column :users, :city, :string
    add_column :users, :state, :string
    add_column :users, :zip, :string
    add_column :users, :neighborhood, :string
    add_column :users, :provider, :string
    add_column :users, :uid, :string
    add_column :users, :token, :string
  end
end
