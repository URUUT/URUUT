class AddFieldsToPost < ActiveRecord::Migration
  def change
    add_column :posts, :title, :string
    add_column :posts, :body, :text
    add_column :posts, :user_id, :integer
    add_column :posts, :project_id, :integer

    add_index :posts, :user_id
    add_index :posts, :project_id
  end
end
