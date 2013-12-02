class AddPartialToProject < ActiveRecord::Migration
  def change
    add_column :projects, :partial_funding, :boolean, :default => false
  end
end
