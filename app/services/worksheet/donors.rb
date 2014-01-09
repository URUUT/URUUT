class Worksheet::Donors < Worksheet::Base

  def initialize(xls, funders)
    super(xls, funders, 'Donors')
  end

private
  def attributes
    [:email, :first_name, :last_name, :neighborhood, :city, :state, :zip,
     :website, :organization, :level, :uruut_point]
  end
end
