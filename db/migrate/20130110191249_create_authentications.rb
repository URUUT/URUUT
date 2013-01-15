class CreateAuthentications < ActiveRecord::Migration
  def change
    create_table :authentications do |t|
      t.string :user_id
      t.string :provider
      t.string :uid
      t.string :token
      t.string :token_secret

      t.timestamps
    end
  end
end
