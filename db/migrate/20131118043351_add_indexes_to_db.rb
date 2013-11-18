class AddIndexesToDb < ActiveRecord::Migration
  def change
  	add_index :contacts, :user_id
  	add_index :donations, :user_id
  	add_index :identities, :user_id
  	add_index :merit_actions, :user_id
  	add_index :projects, :user_id
  	add_index :services, :user_id

  	add_index :documents, :project_id
  	add_index :donations, :project_id
  	add_index :galleries, :project_id
  	add_index :milestoneemails, :project_id
  	add_index :project_sponsors, :project_id
  	add_index :project_updates, :project_id
  	add_index :sponsorship_benefits, :project_id

  	add_index :merit_scores, :sash_id
  	add_index :users, :sash_id

  	add_index :project_sponsors, :sponsor_id
  	add_index :project_sponsors, :sponsor_type

  	add_index :sponsorship_benefits, :sponsorship_level_id

  	add_index :merit_activity_logs, :related_change_id
  	add_index :merit_activity_logs, :related_change_type
  end
end
