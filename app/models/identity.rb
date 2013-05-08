class Identity < ActiveRecord::Base
  attr_accessible :provider, :token, :uid, :user_id
end
