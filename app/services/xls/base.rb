class Xls::Base

  attr_reader :file_path

  def initialize(funders)
    @file_path = 'tmp/project_funders.xls'
    @funders   = funders
    @xls       = WriteExcel.new(@file_path)
    @worksheet = @xls.add_worksheet
  end

  def create
    funders.each_with_index do |funder, row|
      attributes.each_with_index do |attribute, column|
        worksheet.write(row, column, funder.send(attribute))
      end
    end

    xls.close

    self
  end

private
  attr_reader :funders, :xls, :worksheet

end
