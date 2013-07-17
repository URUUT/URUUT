class ChangePressReleaseDateToText < ActiveRecord::Migration
  def up
    change_column :press_releases, :release_date, :string
  end

  def down
  end
end
