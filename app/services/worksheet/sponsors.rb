class Worksheet::Sponsors < Worksheet::Base

  def initialize(xls, project)
    @project = project
    super(xls, project, project_sponsors, 'Project Sponsors')
  end

private
  attr_reader :project

  def attributes(project_sponsor)
    project_sponsor_benefit = benefit(project_sponsor)

    { project_name: project.title,
      email:        project_sponsor.sponsor.email,
      name:         project_sponsor.name,
      cost:         project_sponsor.cost,
      benefit:      project_sponsor_benefit.name }
  end

  def project_sponsors
    @project_sponsors = project.project_sponsors
  end

  def column_titles
    [:project_name, :email, :name, :cost, :benefit]
  end

  def benefit(project_sponsor)
    SponsorshipBenefit.for_project(project).with_project_sponsor_level(project_sponsor).first
  end
end
