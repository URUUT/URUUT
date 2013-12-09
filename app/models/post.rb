class Post < ActiveRecord::Base
  attr_accessible :title, :body, :user_id, :project_id

  belongs_to :user
  has_many :comments, dependent: :destroy
end
