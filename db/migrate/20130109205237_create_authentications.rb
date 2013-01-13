class CreateAuthentications < ActiveRecord::Migration
  def change
    create_table :authentications do |t|
      t.string :provider
      t.string :name
      t.string :uid

      t.timestamps
    end
  end
end
