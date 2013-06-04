class AddUruutPointToUsers < ActiveRecord::Migration
  def change
    add_column :users, :uruut_point, :integer, :default => 0
  end
end
