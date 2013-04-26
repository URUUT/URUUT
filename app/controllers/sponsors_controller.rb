class SponsorsController < ApplicationController

  def new
    @project = Project.find(params[:project_id])
    @sponsor = Sponsor.new
    render :layout => 'landing'
  end

  def create
    @sponsor = Sponsor.create(params[:sponsor])
    @sponsor.update_attribute(:name, params[:sponsor][:card_name])
    @project = ProjectSponsor.create(params[:project_sponsor])
    cost = SponsorshipLevel.find(params[:project_sponsor][:level_id]).cost
    @project.update_attribute(:cost, cost)

    redirect_to root_url
  end
end
