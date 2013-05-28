class Perk < ActiveRecord::Base
  attr_accessible :amount, :description, :name, :limit, :perks_available
  belongs_to :project
end
