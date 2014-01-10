class Membership < ActiveRecord::Base
  belongs_to :user
  has_one    :subscription
  attr_accessible :kind
end
