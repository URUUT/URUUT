class PagesController < ApplicationController

  def index
  	@projects = Project.find(:all)
  end

  def discover
  	@projects = Project.find(:all)
  	@category = Project.where("category = ?", params[:category])
  end

  def categories
  	@category = Project.where("category = ?", params[:category])
  end

end
