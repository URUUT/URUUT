class PagesController < ApplicationController
	 
  def index
  	@projects = Project.find(:all)
  end
end
