class AddFieldsToTaxReport < ActiveRecord::Migration
  def change
  	add_column :tax_reports, :url, :string
  	add_column :tax_reports, :user_id, :integer
  end
end
