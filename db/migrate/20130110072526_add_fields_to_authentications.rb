class AddFieldsToAuthentications < ActiveRecord::Migration
  def change
    add_column :authentications, :token, :string
    add_column :authentications, :secret, :string
    add_column :authentications, :link, :string
  end
end
