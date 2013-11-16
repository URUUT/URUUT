class AddDefaultToRoles < ActiveRecord::Migration
  def change
    change_column :users, :role, :string, :default => ""
  end
end
