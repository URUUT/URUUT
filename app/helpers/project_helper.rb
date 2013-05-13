module ProjectHelper

  def show_title(id)
    SponsorshipLevel.find(id).name
  end
end
