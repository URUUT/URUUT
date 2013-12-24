class AddTimestampsToPosts < ActiveRecord::Migration
  def change
    unless column_exists? :created_at
      add_column :posts, :created_at, :datetime
    end
    unless column_exists? :updated_at
      add_column :posts, :updated_at, :datetime
    end
  end
end
