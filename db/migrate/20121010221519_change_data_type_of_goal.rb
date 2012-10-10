class ChangeDataTypeOfGoal < ActiveRecord::Migration
  def self.up
    change_table :projects do |t|
      t.change :goal, :string
    end
  end

  def self.down
    change_table :projects do |t|
      t.change :goal, :integer
    end
  end
end
