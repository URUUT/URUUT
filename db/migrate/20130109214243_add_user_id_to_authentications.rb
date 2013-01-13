class AddUserIdToAuthentications < ActiveRecord::Migration
  def change
    add_column :authentications, :user_id, :string
  end
end
