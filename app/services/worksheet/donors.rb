class Worksheet::Donors < Worksheet::Base

  def initialize(xls, project)
    @project = project
    super(xls, project, funders, 'Donors')
  end

private
  attr_reader :project

  def attributes
    [:email, :first_name, :last_name, :neighborhood, :city, :state, :zip,
     :website, :organization, :level, :uruut_point]
  end

  def funders
    @funders = User.unique_project_donors(project)
  end
end
