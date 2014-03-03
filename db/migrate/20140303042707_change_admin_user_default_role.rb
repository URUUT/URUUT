class ChangeAdminUserDefaultRole < ActiveRecord::Migration
  def change
    change_column :admin_users, :role, :string, default: 'member'
  end
end
