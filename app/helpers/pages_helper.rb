module PagesHelper
  def campaign_days_left(project)
    (project.campaign_deadline.to_date - Time.now.to_date).to_i rescue 0
  end
end
