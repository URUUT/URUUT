class Worksheet::Base

  def initialize(xls, funders)
    @funders   = funders
    @worksheet = xls.add_worksheet
  end

  def create
    funders.each_with_index do |funder, row|
      attributes.each_with_index do |attribute, column|
        worksheet.write(row, column, funder.send(attribute))
      end
    end
  end

private
  attr_reader :funders, :worksheet

end
