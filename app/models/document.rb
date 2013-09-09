class Document < ActiveRecord::Base
  attr_accessible :filename, :public_id, :project_id
  belongs_to :project
end
