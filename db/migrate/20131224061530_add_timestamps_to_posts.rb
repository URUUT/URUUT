class AddTimestampsToPosts < ActiveRecord::Migration
  def change
    unless column_exists? :posts, :created_at, :datetime
      add_column :posts, :created_at, :datetime
    end
    unless column_exists? :posts, :updated_at, :datetime
      add_column :posts, :updated_at, :datetime
    end
  end
end
