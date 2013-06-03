class AddConfirmed < ActiveRecord::Migration
  def change
    add_column :project_sponsors, :confirmed, :boolean, default: false
    add_column :project_sponsors, :type, :string
    add_column :donations, :confirmed, :boolean, default: false
  end
end
