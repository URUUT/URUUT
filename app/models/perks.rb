class Perk < ActiveRecord::Base
  attr_accessible :amount, :description, :name
  belongs_to :project
end
