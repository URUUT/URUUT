class AddFieldsToSessions < ActiveRecord::Migration
  def change
    add_column :sessions, :session_id, :string
    add_column :sessions, :data, :text
  end
end
