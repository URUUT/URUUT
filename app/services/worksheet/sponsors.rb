class Worksheet::Sponsors < Worksheet::Base

private
  def attributes
    [:name, :payment, :status, :level_id, :site, :confirmed, :sponsor_type,
     :anonymous, :approved]
  end
end
