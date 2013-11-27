module PagesHelper
  def campaign_days_left(project)
    (Date.current - project.approval_date.to_date).to_i rescue 0
  end
end
