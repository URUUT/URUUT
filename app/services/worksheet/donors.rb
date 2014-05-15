class Worksheet::Donors < Worksheet::Base

  def initialize(xls, project)
    @project = project
    super(xls, project, funders, 'Donors')
  end

private
  attr_reader :project

  def attributes(donation)
    funder = get_founder(donation)

    { project_name: project.title,
      email:        funder.email,
      first_name:   funder.first_name,
      last_name:    funder.last_name,
      amount:       donation.amount,
      perk:         donation.perk_name,
      description:  donation.description }
  end

  def funders
    @donations ||= project.donations
  end

  def get_founder(donation)
    donation.user
  end

  def column_titles
    [:project_name, :email, :first_name, :last_name, :amount, :perk, :description]
  end
end
