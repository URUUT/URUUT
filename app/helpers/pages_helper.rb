module PagesHelper
  def campaign_days_left(project)
    (project.campaign_deadline.to_date - project.approval_date.to_date).to_i rescue 0
  end
end
