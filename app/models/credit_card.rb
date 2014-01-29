class CreditCard
  extend ActiveModel::Naming
  include ActiveModel::Conversion

  attr_accessor :number, :exp_month, :exp_year, :cvc, :name, :billing_address,
                :city, :zip_code, :state

  def initialize(attributes={})
    @number = attributes[:number]
    @exp_month = attributes[:exp_month]
    @exp_year = attributes[:exp_year]
    @cvc = attributes[:cvc]
    @name = attributes[:name]
    @billing_address = attributes[:billing_address]
    @city = attributes[:city]
    @zip_code = attributes[:zip_code]
    @state = attributes[:state]
  end

  def details_as_hash
    {
      number:        number,
      exp_month:     exp_month,
      exp_year:      exp_year,
      cvc:           cvc,
      name:          name,
      address_line1: billing_address,
      address_city:  city,
      address_zip:   zip_code,
      address_state: state
    }
  end

  def persisted?
    false
  end
end