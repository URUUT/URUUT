class Document < ActiveRecord::Base
  attr_accessible :filename, :url, :project_id
  belongs_to :project
end
