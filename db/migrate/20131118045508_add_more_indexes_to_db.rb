class AddMoreIndexesToDb < ActiveRecord::Migration
  def change
  	add_index :perks, :project_id
  	add_index :sessions, :session_id
  end
end
