class AddFieldsToPerks < ActiveRecord::Migration
  def change
    add_column :perks, :name, :string
    add_column :perks, :amount, :float
    add_column :perks, :description, :text
    add_column :perks, :project_id, :integer
  end
end
