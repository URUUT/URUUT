module ProjectsHelper

	def time_left(endDate, startDate)
    endDate = Date.parse(startDate) + endDate.to_i.days
    finalDate = endDate - Date.today
    return finalDate.to_i
  end

  def project_title(id)
    project = Project.find(id)
    return project.title
  end

  def current_project
    session[:current_project]
  end

  def project_categories
    [
      ['Art / Culture'],
      ['Athletic / Sports'],
      ['Education / Schools'],
      ['Health / Wellness'],
      ['Local Business'],
      ['Neighborhood Improvements'],
      ['Parks & Recreation'],
      ['Safety'],
      ['Sustainability / Energy'],
      ['Technology'],
      ['Transit / Transportation'],
      ['Walkability / Bike / Paths']
    ]
  end

  def project_org_type
    [
      ['School'],
      ['Church'],
      ['Municipal'],
      ['Member'],
      ['Foundation'],
      ['Other Civic'],
      ['Special Situation']
    ]
  end

  def project_org_class
    [
      ['501(c)(3)'],
      ['501(c)(4)'],
      ['501(c)(6)'],
      ['501(c)(7)'],
      ['170(c)(1)']
    ]
  end

  def project_duration(duration)
    if !duration.nil?
      Time.parse(duration).strftime("%m/%d/%y")
    end
  end

  def stored_content
    content_for :description do
      "This is some text"
    end
  end

  def action_image(image, video)
    if !image.blank? or !video.blank?
      ""
    else
      "display:none"
    end
  end

  def campaign_days_left(project)
    ((project.campaign_deadline.end_of_day - DateTime.current) / 1.day).to_i rescue 0
  end

  def default_perk
    ["10", "25", "50", "100", "250"]
  end

  def image_sponsor(sponsor)
    if sponsor.anonymous
      image_tag("uruut-fb-og.png", class: "img-polaroid")
    else
      link_to(image_tag(sponsor.logo, class: "img-polaroid"), recognize_url(sponsor.site), target: "_blank")
    end
  end

  def sponsor_name(sponsor)
    if sponsor.anonymous
      "<a href='javascript:void(0)'>ANONYMOUS <br> SPONSOR</a>"
    else
      link_to(sponsor.name, recognize_url(sponsor.site), target: "_blank", style: "color: #70bf4c;")
    end
  end

  def sponsor_link(sponsor)
    unless sponsor.site.nil? or sponsor.anonymous
      link_to(strip_url(sponsor.site), recognize_url(sponsor.site), target: "_blank", style: "")
    end
  end

  def sponsor_item(sponsor)
    "<div class='sponsor'>#{image_sponsor(sponsor)}
      <h5>#{sponsor_name(sponsor)}</h5>
      #{sponsor_link(sponsor)}
    </div>".html_safe
  end

  def any_project_donors_or_sponsors?(project)
    User.who_donated_to(project).any? ||
    project.project_sponsors.any?
  end

  def level_name(default, level)
    return default if level.empty?
    (level)? level.name : default
  end

  def level_cost(default, level, project)
    default_cost = SponsorshipLevel.default_costs(default, project)
    return default_cost.to_i if level.empty?
    (level.cost)? level.cost.to_i : default_cost.to_i
  end

end
