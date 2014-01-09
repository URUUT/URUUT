class Worksheet::Sponsors < Worksheet::Base

  def initialize(xls, project)
    @project = project
    super(xls, project, funders, 'Project Sponsors')
  end

private
  attr_reader :project

  def attributes
    [:name, :payment, :status, :level_id, :site, :confirmed, :sponsor_type,
     :anonymous, :approved]
  end

  def funders
    @funders = project.project_sponsors
  end
end
