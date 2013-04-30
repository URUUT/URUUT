class SponsorsController < ApplicationController

  before_filter :project_id, except: [:create]

  def new
    @sponsor = Sponsor.new
    @sponsorship_levels = @project.sponsorship_levels
    render :layout => 'landing'
  end

  def create
    sponsor = params[:sponsor]
    project = Project.find(params[:project_id])
    sponsor_name = sponsor[:payment_type].eql?("Wire Transfer") ? sponsor[:name] : sponsor[:card_name]
    cost = SponsorshipLevel.find(params[:project_sponsor][:level_id]).cost
    @sponsor = Sponsor.new(params[:sponsor])
    @sponsor.month = params[:sponsor][:month].to_i
    @sponsor.year_card = params[:sponsor][:years]
    @sponsor.name = sponsor_name
    @sponsor.save(validate: false)
    @project_sponsor = ProjectSponsor.create(params[:project_sponsor])
    @project_sponsor.update_attributes({cost: cost, project_id: project.id, sponsor_id: @sponsor.id,
                                      level_id: params[:project_sponsor][:level_id]})

    redirect_to confirmation_url(project.id, @sponsor.id)
  end

  def get_sponsorship_levels
    project = Project.find(params[:project_id])
    @sponsorship_level = project.sponsorship_levels.find(params[:sponsor_id])

    respond_to :js
  end

  def confirmation
    @sponsor = Sponsor.find(params[:id])
    @project_sponsor = @project.project_sponsors.find_by_sponsor_id(@sponsor.id)
    @sponsorship_level = SponsorshipLevel.find(@project_sponsor.level_id)
  end

  def confirm_sponsor
    @sponsor = Sponsor.find(params[:sponsor_id])
    project_sponsor = ProjectSponsor.find_by_project_id(params[:project_id])
    project_sponsor.update_attribute(:status, "confirmed")

    redirect_to root_url, notice: "Great! you have successfully registered as a sponsor"
  end


  private

  def project_id
    @project = Project.find(params[:project_id])
  end
end
