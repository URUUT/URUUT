class Worksheet::Sponsors < Worksheet::Base

  def initialize(xls, project)
    @project = project
    super(xls, project, project_sponsors, 'Project Sponsors')
  end

private
  attr_reader :project

  def attributes(project_sponsor)
    project_sponsor_benefit = benefit(project_sponsor)

    { project_name:      project.project_title || "",
      organization_name: project_sponsor.name || "",
      name:              project_sponsor.sponsor.name || "",
      email:             project_sponsor.sponsor.email || "",
      amount:            project_sponsor.cost || "",
      level:             project_sponsor.sponsorship_level.name || "",
      description:       project_sponsor_benefit || "" }
  end

  def project_sponsors
    @project_sponsors = project.project_sponsors
  end

  def column_titles
    [:project_name, :organization_name, :name, :email, :amount, :level, :description]
  end

  def benefit(project_sponsor)
    SponsorshipBenefit.for_project(project).with_project_sponsor_level(project_sponsor).first
  end
end
