class CreatePosts < ActiveRecord::Migration
  def change
  	unless table_exists? :posts
    	create_table :posts
    end

    unless column_exists? :posts, :title, :string
      add_column :posts, :title, :string
    end

    unless column_exists? :posts, :body, :text
      add_column :posts, :body, :text
    end

    unless column_exists? :posts, :project_id, :integer
      add_column :posts, :project_id, :integer
    end

    unless column_exists? :posts, :user_id, :integer
      add_column :posts, :user_id, :integer
    end

    unless index_exists? :posts, :project_id
      add_index :posts, :project_id, :name => "index_posts_on_project_id"
    end

    unless index_exists? :posts, :user_id
      add_index :posts, :user_id, :name => "index_posts_on_user_id"
    end

  end
end
