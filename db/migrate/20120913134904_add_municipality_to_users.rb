class AddMunicipalityToUsers < ActiveRecord::Migration
  def change
    add_column :users, :municipality, :boolean, :default => false
  end
end
