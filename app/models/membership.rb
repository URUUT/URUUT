class Membership < ActiveRecord::Base
  belongs_to :user
  attr_accessible :kind
end
