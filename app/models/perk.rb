class Perk < ActiveRecord::Base
  attr_accessible :amount, :description, :name, :limit, :perks_available, :project_id
  belongs_to :project
end
