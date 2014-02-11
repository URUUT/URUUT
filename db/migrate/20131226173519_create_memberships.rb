class CreateMemberships < ActiveRecord::Migration
  def change
    create_table :memberships do |t|
      t.references :user
      t.string     :kind

      t.timestamps
    end

    add_index :memberships, :user_id
  end
end
