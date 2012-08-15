class ChangeDataTypeOfDuration < ActiveRecord::Migration
  def up
  	change_table :projects do |t|
      t.change :duration, :string
    end
  end

  def down
  	change_table :projects do |t|
      t.change :duration, :integer
    end
  end
end
