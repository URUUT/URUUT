class CreateMarketingInfos < ActiveRecord::Migration
  def change
    create_table :marketing_infos do |t|
      t.integer :user_id
      t.string :first_name
      t.string :last_name
      t.string :email

      t.timestamps
    end
  end
end
