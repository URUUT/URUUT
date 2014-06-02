class ManualDonation < ActiveRecord::Base
  belongs_to :project

  attr_accessible :email, :first_name, :last_name, :project_id, :amount

  validates :email, :first_name, :last_name, :amount, presence: true

end
