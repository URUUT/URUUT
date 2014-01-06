class XlsService

  def initialize(funders)
    @funders = funders
  end

  def create
    resource = get_resource
    resource.create
  end

private

  attr_reader :funders

  def get_resource
    case funders.first.class
    when User           then Xls::Donors.new(funders)
    when ProjectSponsor then Xls::Sponsors.new(funders)
    end
  end

end
