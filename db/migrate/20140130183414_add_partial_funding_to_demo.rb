class AddPartialFundingToDemo < ActiveRecord::Migration
  def change
    add_column :demos, :partial_funding, :integer
  end
end
