class CreateSponsors < ActiveRecord::Migration
  def change
    create_table :sponsors do |t|

      t.timestamps
    end
  end
end
