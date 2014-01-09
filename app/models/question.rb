class Question < ActiveRecord::Base
  belongs_to :user
  belongs_to :project

  attr_accessible :body, :subject
end
