class CreateComments < ActiveRecord::Migration
  def change
  	unless table_exists? :comments
    	create_table :comments
    end

    unless column_exists? :comments, :body, :text
      add_column :comments, :body, :text
    end

    unless column_exists? :comments, :post_id, :integer
      add_column :comments, :post_id, :integer
    end

    unless column_exists? :comments, :user_id, :integer
      add_column :comments, :user_id, :integer
    end

    unless index_exists? :comments, :post_id
    	add_index :comments, :post_id, :name => "index_comments_on_post_id"
    end

    unless index_exists? :comments, :user_id
	  	add_index :comments, :user_id, :name => "index_comments_on_user_id"
	end

  end
end
