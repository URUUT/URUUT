class RemoveKindFromMembership < ActiveRecord::Migration
  def up
    remove_column :memberships, :kind
  end

  def down
    add_column :memberships, :kind, :string
  end
end
