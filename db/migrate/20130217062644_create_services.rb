class CreateServices < ActiveRecord::Migration
  def change
    create_table :services do |t|
      t.string :uid
      t.string :provider
      t.references :user
    end

    add_index :services, :user_id
  end
end
