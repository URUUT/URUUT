class AddMonthAndYearToSponsor < ActiveRecord::Migration
  def change
    add_column :sponsors, :month, :integer
    add_column :sponsors, :year_card, :integer
    remove_column :sponsors, :card_expiration
  end
end
