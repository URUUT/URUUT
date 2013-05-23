module ProjectHelper

  def action_image(image, video)
    if !image.blank? or !video.blank?
      ""
    else
      "display:none"
    end
  end

end
