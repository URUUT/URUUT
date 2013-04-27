class AddOrganizationAndMissionToUsers < ActiveRecord::Migration
  def change
    add_column :users, :organization, :string
    add_column :users, :mission, :text
  end
end
