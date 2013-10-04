class CreateProjectAdminDocuments < ActiveRecord::Migration
  def change
    create_table :documents do |t|
      t.string :filename
      t.string :public_id
      t.integer :project_id

      t.timestamps
    end
  end
end
