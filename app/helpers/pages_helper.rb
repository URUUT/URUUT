module PagesHelper
  def campaign_days_left(project)
    ((project.campaign_deadline.end_of_day - DateTime.current) / 1.day).to_i rescue 0
  end
end
