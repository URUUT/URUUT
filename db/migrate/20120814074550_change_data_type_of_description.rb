class ChangeDataTypeOfDescription < ActiveRecord::Migration
  def up
  	change_table :projects do |t|
      t.change :description, :text
    end
  end

  def down
  	change_table :projects do |t|
      t.change :description, :text
    end
  end
end
