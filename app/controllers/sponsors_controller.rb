class SponsorsController < ApplicationController

  before_filter :project_id, except: [:create, :thank_you, :share_email]

  def new
    @sponsor = Sponsor.new
    @project = Project.find(params[:project_id])
    logger.debug(@project.to_yaml)
    render :layout => 'landing'
  end

  def edit
    @sponsor = Sponsor.find(params[:id])
    @project_sponsor = @sponsor.project_sponsors.first
    render :layout => 'landing'
  end

  def update
    @sponsor = Sponsor.find(params[:id])
    @project_sponsor = @sponsor.project_sponsors.first
    sponsor = params[:sponsor]
    sponsor_name = sponsor[:payment_type].eql?("Wire Transfer") ? sponsor[:name] : sponsor[:card_name]
    cost = SponsorshipLevel.find(params[:project_sponsor][:level_id]).cost
    params[:sponsor][:name] = sponsor_name
    @sponsor.update_attributes(params[:sponsor])
    @project_sponsor.update_attributes(params[:project_sponsor].merge({cost: cost, project_id: params[:project_id], sponsor_id: @sponsor.id,
                                      level_id: params[:project_sponsor][:level_id]}))
    redirect_to confirmation_url(params[:project_id], @sponsor.id)
  end

  def create
    # current_user = :current_user
    sponsor = params[:sponsor]
    sponsor_name = sponsor[:payment_type].eql?("Wire Transfer") ? sponsor[:name] : sponsor[:card_name]
    cost = SponsorshipLevel.find(params[:project_sponsor][:level_id]).cost
    params[:sponsor][:name] = sponsor_name
    card_type = params[:project_sponsor][:card_type]
    last4 = params[:project_sponsor][:card_last4]
    token = params[:token]
    
    logger.debug(sponsor)
    logger.debug(sponsor_name)
    logger.debug(cost)
    logger.debug(session[:current_user])
    logger.debug(:project_id)
    @sponsor = Sponsor.new(params[:sponsor])
    @sponsor.save(validate: false)
    logger.debug
    @project_sponsor = ProjectSponsor.new(params[:project_sponsor])
    #@project_sponsor.save!
    #logger.debug(@project_sponsor)
    @project_sponsor.update_attributes({cost: cost, project_id: params[:project_id], sponsor_id: @sponsor.id,
                                      level_id: params[:project_sponsor][:level_id], card_token: token, card_type: card_type, card_last4: last4})
    
    session[:project_sponsor] = @project_sponsor
    
    logger.debug("Project Sponsors: #{session[:project_sponsor].to_yaml}")

    # charge = Stripe::Charge.create({:amount => cost, :currency => "usd", :card => params[:stripeToken]});

    redirect_to confirmation_url(params[:project_id], @sponsor.id)
  end

  def get_sponsorship_levels
    project = Project.find(params[:project_id])
    @sponsorship_level = SponsorshipLevel.find(params[:sponsor_id])

    respond_to :js
  end

  def confirmation
    @sponsor = Sponsor.find(params[:id])
    @project_sponsor = @project.project_sponsors.find_by_sponsor_id(@sponsor.id)
    logger.debug(@project_sponsor)
    @sponsorship_level = SponsorshipLevel.find(@project_sponsor.level_id)
  end

  def thank_you
    @project = Project.find(params[:project_id])
    project_sponsor = @project.project_sponsors.where(project_id: @project.id, sponsor_id: params[:sponsor_id]).first
    @sponsorship_level = SponsorshipLevel.find(project_sponsor.level_id)
    @need_doctype = true
  end

  def confirm_sponsor
    @sponsor = Sponsor.find(params[:sponsor_id])
    project_sponsor = ProjectSponsor.find_by_project_id(params[:project_id])
    project_sponsor.update_attribute(:status, "confirmed")

    redirect_to project_url(params[:project_id]), notice: "Great! you have successfully registered as a sponsor"
  end

  def share_email
    SponsorMailer.share_project(params[:emails], params[:project_id]).deliver
    respond_to :js
  end

  private

  def project_id
    @project = Project.find(params[:project_id])
    @sponsorship_levels = SponsorshipLevel.all
  end
end
