class XlsService

  def initialize(donors, project_sponsors)
    @donors = donors
    @project_sponsors = project_sponsors
    @xls = WriteExcel.new(file_path)
  end

  def create
    create_donors_worksheet
    create_project_sponsors_worksheet

    xls.close

    self
  end

  def file_path
    'tmp/project_funders.xls'
  end

private

  attr_reader :donors, :project_sponsors, :xls

  def create_donors_worksheet
    Worksheet::Donors.new(xls, donors).create
  end

  def create_project_sponsors_worksheet
    Worksheet::Sponsors.new(xls, project_sponsors).create
  end

end
