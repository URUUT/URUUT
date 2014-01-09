class Question < ActiveRecord::Base
  belongs_to :user
  attr_accessible :email, :user_id, :body, :subject
end
