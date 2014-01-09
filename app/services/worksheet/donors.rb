class Worksheet::Donors < Worksheet::Base

  def initialize(xls, project)
    @project = project
    super(xls, project, funders, 'Donors')
  end

private
  attr_reader :project

  def attributes(funder)
    funder_donation = donation(funder)

    { project_name: project.title,
      email:        funder.email,
      first_name:   funder.first_name,
      last_name:    funder.last_name,
      amount:       funder_donation.amount,
      perk:         funder_donation.perk_name,
      description:  funder_donation.description }
  end

  def funders
    @funders = User.unique_project_donors(project)
  end

  def donation(funder)
    Donation.with_funder(funder).with_project(project).first
  end

  def column_titles
    [:project_name, :email, :first_name, :last_name, :amount, :perk, :description]
  end
end
