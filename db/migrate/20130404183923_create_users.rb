class CreateUsers < ActiveRecord::Migration
  def up
    create_table :users
  end

  def down
  end
end
