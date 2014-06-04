class CreateManualDonations < ActiveRecord::Migration
  def change
    create_table :manual_donations do |t|
      t.string :first_name
      t.string :last_name
      t.string :email
      t.integer :project_id
      t.decimal   :amount, precision: 8, scale: 2

      t.timestamps
    end
    add_index :manual_donations, :project_id
  end
end
