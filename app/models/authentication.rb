class Authentication < ActiveRecord::Base
  belongs_to :user
  attr_accessible :name, :provider, :uid, :password, :email
end
