class ChangeFoundedDateOfDemoToInteger < ActiveRecord::Migration
  def up
    remove_column :demos, :founded_date
    add_column    :demos, :founded_date, :integer
  end

  def down
    remove_column :demos, :founded_date
    add_column    :demos, :founded_date, :date
  end
end
