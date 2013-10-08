class Message < ActiveRecord::Base
  attr_accessible :message, :project_id
  belongs_to :project
end
