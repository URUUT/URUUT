class AddFieldsToServices < ActiveRecord::Migration
  def change
    add_column :services, :uid, :string
    add_column :services, :provider, :string
    add_column :services, :user_id, :integer
  end
end
