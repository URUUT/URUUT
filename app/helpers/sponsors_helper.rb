module SponsorsHelper

  def sponsor_option(id)
    sponsorship_levels_active = []
    project = Project.find(id)
    level_group = project.project_sponsors.count(group: "level_id")

    level_group.each do |key, value|
      active = project.sponsorship_levels.where("id = ? AND funding_goal > ?", key, value)
      sponsorship_levels_active << active if !active.size.zero?
    end

    return sponsorship_levels_active.flatten
  end
end
