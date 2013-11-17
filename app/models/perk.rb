class Perk < ActiveRecord::Base
  attr_accessible :amount, :description, :name, :limit, :perks_available, :project_id, :perk_limit
  belongs_to :project

  def get_perk_name(amount)
  	case amount
      when "10"
        self.name = "Level 1"
      when "25"
        self.name = "Level 2"
      when "50"
        self.name = "Level 3"
      when "100"
        self.name = "Level 4"
      when "250"
        self.name = "Level 5"
      else
        self.name = "Custom"
    end
    self.name
  end
end
