class SponsorsController < ApplicationController

  before_filter :project_id, except: [:create]

  def new
    @sponsor = Sponsor.new
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
    current_user = :current_user
    Stripe.api_key = "sk_test_XF9K5nq63HTSmTK1ZMiW6tvw"
    sponsor = params[:sponsor]
    sponsor_name = sponsor[:payment_type].eql?("Wire Transfer") ? sponsor[:name] : sponsor[:card_name]
    cost = SponsorshipLevel.find(params[:project_sponsor][:level_id]).cost
    params[:sponsor][:name] = sponsor_name

    @sponsor = Sponsor.new(params[:sponsor])
    @sponsor.save(validate: false)
    @project_sponsor = ProjectSponsor.create(params[:project_sponsor])
    @project_sponsor.update_attributes({cost: cost, project_id: params[:project_id], sponsor_id: @sponsor.id,
                                      level_id: params[:project_sponsor][:level_id], card_token: params[:stripeToken]})

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
    @sponsorship_level = SponsorshipLevel.find(@project_sponsor.level_id)
  end

  def confirm_sponsor
    @sponsor = Sponsor.find(params[:sponsor_id])
    project_sponsor = ProjectSponsor.find_by_project_id(params[:project_id])
    project_sponsor.update_attribute(:status, "confirmed")

    redirect_to project_url(params[:project_id]), notice: "Great! you have successfully registered as a sponsor"
  end

  private

  def project_id
    @project = Project.find(params[:project_id])
    @sponsorship_levels = SponsorshipLevel.all
  end
end
