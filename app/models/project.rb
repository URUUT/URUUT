class Project < ActiveRecord::Base
  attr_accessible :category, :description, :duration, :goal, :location, :title, :images_attributes
  attr_writer :current_step
  attr_reader :current_step

  has_many :images

  accepts_nested_attributes_for :images

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

end
