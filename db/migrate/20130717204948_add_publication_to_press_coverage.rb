class AddPublicationToPressCoverage < ActiveRecord::Migration
  def change
    add_column :press_coverages, :publication, :string
  end
end
