class Worksheet::ManualDonations < Worksheet::Base

  def initialize(xls, project)
    @project = project
    super(xls, project, project.manual_donations, 'Manual Donations')
  end

private
  attr_reader :project

  def attributes(donation)
    { project_name: donation.project.title,
      email:        donation.email,
      first_name:   donation.first_name,
      last_name:    donation.last_name,
      amount:       donation.amount }
  end

  def column_titles
    [:project_name, :email, :first_name, :last_name, :amount ]
  end
end
