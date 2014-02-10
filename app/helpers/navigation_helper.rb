module NavigationHelper
  def features_page?
    features_pages = ['/pages/fundraising', '/pages/donor_relationship', '/pages/analytics', '/pages/donor_convenience']
    features_pages.include?(request.path)
  end
end
