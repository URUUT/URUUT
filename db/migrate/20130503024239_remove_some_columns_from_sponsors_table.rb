class RemoveSomeColumnsFromSponsorsTable < ActiveRecord::Migration
  def change
    # remove_column :sponsors, :card_number
    remove_column :sponsors, :cvc
    remove_column :sponsors, :month
    remove_column :sponsors, :year_card
  end
end
