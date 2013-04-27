module SponsorsHelper

  def sponsor_option(id)
    Project.find(id).sponsorship_levels.map {|level| [level.name, level.id] }
  end
end
