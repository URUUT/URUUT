class Project < ActiveRecord::Base

  attr_accessible :category, :description, :duration, :goal, :location, :title, :image, :video, :tags
  attr_writer :current_step
  # attr_reader :current_step
  has_attached_file :image,
       :styles => {
       :thumb=> "100x100#",
       :small  => "400x400>" },
     :storage => :s3,
     :s3_credentials => "#{Rails.root}/config/s3.yml"

  # process_in_background :image

  def current_step
    @current_step || steps.first
  end
  
  def steps
    %w[overview details category]
  end

  def next_step
    self.current_step = steps[steps.index(current_step)+1]
  end

  def previous_step
    self.current_step = steps[steps.index(current_step)-1]
  end

  def first_step?
    current_step == steps.first
  end

  def last_step?
    current_step == steps.last
  end

end
