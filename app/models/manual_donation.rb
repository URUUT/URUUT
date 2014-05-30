class ManualDonation < ActiveRecord::Base
  attr_accessible :email, :first_name, :last_name, :project_id

  belongs_to :project_id
end
