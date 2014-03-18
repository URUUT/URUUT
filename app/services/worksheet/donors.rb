class Worksheet::Donors < Worksheet::Base

  def initialize(xls, project)
    @project = project
    super(xls, project, donations, 'Donors')
  end

private
  attr_reader :project

  def attributes(donation)
    { project_name: donation.project.title,
      email:        donation.user.email,
      first_name:   donation.user.first_name,
      last_name:    donation.user.last_name,
      amount:       donation.amount,
      perk:         donation.perk_name,
      description:  donation.description }
  end

  def donations
    Donation.for_project(project).known_users
  end

  def column_titles
    [:project_name, :email, :first_name, :last_name, :amount, :perk, :description]
  end
end
