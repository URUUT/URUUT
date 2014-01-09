class Worksheet::Base

  def initialize(xls, project, funders, worksheet_name)
    @project   = project
    @funders   = funders
    @worksheet = xls.add_worksheet(worksheet_name)
  end

  def create
    add_title_to_columns

    funders.each_with_index do |funder, row|
      funder_attributes = attributes(funder)
      funder_attributes.each_with_index do |attribute, column|
        worksheet.write(row + 1, column, attribute[1])
      end
    end
  end

private
  attr_reader :project, :funders, :worksheet

  def add_title_to_columns
    column_titles.each_with_index do |title, column|
      worksheet.write(0, column, format_title(title))
    end
  end

  def format_title(title)
    title.to_s.titleize
  end

end
