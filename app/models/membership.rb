class Membership < ActiveRecord::Base
  belongs_to :user
  belongs_to :sponsor
  belongs_to :plan

  attr_accessible :kind
end
