class Authentication < ActiveRecord::Base
  attr_accessible :provider, :token, :token_secret, :uid, :user_id
  belongs_to :user
end
