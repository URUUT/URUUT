class CreateDonations < ActiveRecord::Migration
  def change
    create_table :donations do |t|
      t.integer :user_id
      t.integer :project_id
      t.float :amount
      t.string :token

      t.timestamps
    end
  end
end
