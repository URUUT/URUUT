class SplitNameField < ActiveRecord::Migration
  rename_column :users, :name, :first_name
end
