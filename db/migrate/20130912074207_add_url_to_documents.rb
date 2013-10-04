class AddUrlToDocuments < ActiveRecord::Migration
  def change
    add_column :documents, :url, :string
    remove_column :documents, :public_id
  end
end
