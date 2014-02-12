class Worksheet::Donors < Worksheet::Base

private
  def attributes
    [:email, :first_name, :last_name, :neighborhood, :city, :state, :zip,
     :website, :organization, :level, :uruut_point]
  end
end
