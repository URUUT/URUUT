class Worksheet::Donors < Worksheet::Base

  def initialize(xls, project)
    @project = project
    super(xls, project, funders, 'Donors')
  end

private
  attr_reader :project

  def attributes(funder)
    { project_name: project.title,
      email:        funder.email,
      first_name:   funder.first_name,
      last_name:    funder.last_name,
      amount:       donation(funder).amount,
      perk:         donation(funder).perk_name,
      description:  donation(funder).description }
  end

  def funders
    @funders = User.unique_project_donors(project)
  end

  def donation(funder)
    @donation = Donation.where(user_id: funder, project_id: project).first
  end

  def column_titles
    [:project_name, :email, :first_name, :last_name, :amount, :perk, :description]
  end
end
