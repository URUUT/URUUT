module SponsorsHelper

  def sponsor_option(id)
    sponsorship_levels_active = []
    project = Project.find(id)
    level_groups = project.project_sponsors.count(group: "level_id")
    levels = project.sponsorship_levels.pluck(:id)

    levels.each { |level| level_groups[level] = 0 unless level_groups.keys.include? level }

    level_groups.each do |key, value|
      active = project.sponsorship_levels.where("id = ? AND funding_goal > ?", key, value)
      sponsorship_levels_active << active if !active.size.zero?
    end

    sponsorship_levels_active.flatten
  end

  def default_result(sponsorship_level, selected_level=nil)
    selected_level ? @selected_level : @sponsorship_levels.first
  end

end
