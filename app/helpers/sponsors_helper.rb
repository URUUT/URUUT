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

  def availability(sponsors, level)
    number_of_sponsor = sponsors.where(level_id: level.id).count

    if level.parent_id.eql?(1)
      if number_of_sponsor < 1
        1
      else
        0
      end
    elsif level.parent_id.eql?(2)
      if number_of_sponsor < 3
        3 - number_of_sponsor
      else
        0
      end
    elsif level.parent_id.eql?(3)
      if number_of_sponsor < 5
        5 - number_of_sponsor
      else
        0
      end
    end

  end

  def level_placement_image(parent_id)
    case parent_id
    when 1
      "/assets/platinum-placement.png"
    when 2
      "/assets/gold-placement.png"
    when 3
      "/assets/silver-placement.png"
    when 4
      "/assets/bronze-placement.png"
    end
  end
end
