class Membership < ActiveRecord::Base
  belongs_to :user
  belongs_to :sponsor
  has_one    :plan
  attr_accessible :kind
end
