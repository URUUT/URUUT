class XlsService

  def initialize(project)
    @project = project
    @xls = WriteExcel.new(file_path)
  end

  def create
    create_donors_worksheet
    create_project_sponsors_worksheet
    create_manual_donations_worksheet

    xls.close

    self
  end

  def file_path
    'tmp/project_funders.xls'
  end

private

  attr_reader :project, :xls

  def create_donors_worksheet
    Worksheet::Donors.new(xls, project).create
  end

  def create_project_sponsors_worksheet
    Worksheet::Sponsors.new(xls, project).create
  end

  def create_manual_donations_worksheet
    Worksheet::ManualDonations.new(xls, project).create
  end

end
