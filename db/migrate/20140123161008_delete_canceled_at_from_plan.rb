class DeleteCanceledAtFromPlan < ActiveRecord::Migration
  def up
    remove_column :plans, :canceled_at
  end

  def down
    add_column :plans, :canceled_at, :datetime
  end
end
