class XlsService

  attr_reader :file_path

  def initialize(funders)
    @file_path = 'tmp/project_funders.xls'
    @funders = funders
    @xls = WriteExcel.new(@file_path)
    @worksheet = @xls.add_worksheet
  end

  def create
    @funders.each_with_index do |funder, row|
      attributes.each_with_index do |attribute, column|
        @worksheet.write(row, column, funder.send(attribute))
      end
    end

    @xls.close

    self
  end

private

  def attributes
    @funders.first.is_a?(User) ? donor_attributes : sponsor_attributes
  end

  def sponsor_attributes
    [:name, :payment, :status, :level_id, :site, :confirmed, :sponsor_type,
     :anonymous, :approved]
  end

  def donor_attributes
    [:email, :first_name, :last_name, :neighborhood, :city, :state, :zip,
     :website, :organization, :level, :uruut_point, :role]
  end

end