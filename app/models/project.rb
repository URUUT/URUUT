class Project < ActiveRecord::Base
  attr_accessible :amount, :due_date, :name
end
