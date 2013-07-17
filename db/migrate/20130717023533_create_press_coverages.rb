class CreatePressCoverages < ActiveRecord::Migration
  def change
    create_table :press_coverages do |t|
      t.string :title
      t.string :link
      t.date :release_date

      t.timestamps
    end
  end
end
