class ChangeUserRolesToRole < ActiveRecord::Migration
  def change
    rename_column :users, :roles, :role
    change_column :users, :role, :string
  end
end
