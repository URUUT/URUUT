class Worksheet::Base

  def initialize(xls, project, funders, worksheet_name)
    @project   = project
    @funders   = funders
    @worksheet = xls.add_worksheet(worksheet_name)
  end

  def create
    funders.each_with_index do |funder, row|
      attributes.each_with_index do |attribute, column|
        worksheet.write(row, column, funder.send(attribute))
      end
    end
  end

private
  attr_reader :project, :funders, :worksheet

end
