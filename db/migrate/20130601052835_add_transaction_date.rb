class AddTransactionDate < ActiveRecord::Migration
  def change
    change_table(:project_sponsors) { |t| t.timestamps }
    change_table(:donations) { |t| t.timestamps }
  end
end
