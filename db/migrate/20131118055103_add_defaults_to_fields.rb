class AddDefaultsToFields < ActiveRecord::Migration
  def change
  	change_column :projects, :live, :integer, :default => 0
  	change_column :projects, :perk_permission, :boolean, :default => false
  end
end
