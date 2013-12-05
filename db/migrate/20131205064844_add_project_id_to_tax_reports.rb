class AddProjectIdToTaxReports < ActiveRecord::Migration
  def change
    add_column :tax_reports, :project_id, :integer
    add_index :tax_reports, :project_id
    add_index :tax_reports, :user_id
  end
end
