class Worksheet::Sponsors < Worksheet::Base

  def initialize(xls, funders)
    super(xls, funders, 'Project Sponsors')
  end

private
  def attributes
    [:name, :payment, :status, :level_id, :site, :confirmed, :sponsor_type,
     :anonymous, :approved]
  end
end
