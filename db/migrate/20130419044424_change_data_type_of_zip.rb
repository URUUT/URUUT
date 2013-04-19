class ChangeDataTypeOfZip < ActiveRecord::Migration
  change_column :projects, :zip, :string
end
