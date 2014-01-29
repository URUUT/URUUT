class AddNameToPlan < ActiveRecord::Migration
  def change
    add_column :plans, :name, :string
  end
end
