class CreateTables < ActiveRecord::Migration
  def up
    create_table :donations
    create_table :galleries
    create_table :perks
    create_table :projects
    create_table :services
    create_table :sessions
  end

  def down
  end
end
