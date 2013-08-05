class AddAnonymousToDonationsAndSponsor < ActiveRecord::Migration
  def change
    add_column :donations, :anonymous, :boolean, default: false
    add_column :project_sponsors, :anonymous, :boolean, default: false
  end
end
