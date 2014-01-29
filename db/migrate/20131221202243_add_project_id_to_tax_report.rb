class AddProjectIdToTaxReport < ActiveRecord::Migration
  def change
    unless column_exists? :tax_reports, :project_id, :integer
      add_column :tax_reports, :project_id, :integer
    end

    unless index_exists? :tax_reports, :project_id
      add_index :tax_reports, :project_id, :name => "index_tax_reports_on_project_id"
    end
  end
end
