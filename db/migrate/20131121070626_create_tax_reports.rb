class CreateTaxReports < ActiveRecord::Migration
  def change
    create_table :tax_reports do |t|

      t.timestamps
    end
  end
end
