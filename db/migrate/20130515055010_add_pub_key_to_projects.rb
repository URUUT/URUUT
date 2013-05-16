class AddPubKeyToProjects < ActiveRecord::Migration
  def change
    add_column :projects, :publishable_key, :string
  end
end
