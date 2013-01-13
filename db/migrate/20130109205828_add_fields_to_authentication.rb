class AddFieldsToAuthentication < ActiveRecord::Migration
  def change
    add_column :authentications, :password, :string
    add_column :authentications, :email, :string
  end
end
