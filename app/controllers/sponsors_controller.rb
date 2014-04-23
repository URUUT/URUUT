class SponsorsController < ApplicationController

  before_filter :project_id, except: [:create, :thank_you, :share_email]
  before_filter :authenticate_user!

  skip_before_filter :session_email_forgot_password, :only => [:share_email]

  def new
    @sponsor = Sponsor.new
    @sponsor.anonymous = false
    @project = Project.find(params[:project_id])
    session[:path] = "sponsor_new"
    case params[:level]
      when 'platinum'
        @first_benefits = @project.sponsorship_benefits.where(status: true).group_by {|sponsor| sponsor.sponsorship_level_id}[1]
        @cost = @project.goal.to_i * 0.25
        @level = "Platinum"
        session[:level_id] = 1
      when 'gold'
        @first_benefits = @project.sponsorship_benefits.where(status: true).group_by {|sponsor| sponsor.sponsorship_level_id}[2]
        @cost = @project.goal.to_i * 0.1
        @level = "Gold"
        session[:level_id] = 2
      when 'silver'
        @first_benefits = @project.sponsorship_benefits.where(status: true).group_by {|sponsor| sponsor.sponsorship_level_id}[3]
        @cost = @project.goal.to_i * 0.05
        @level = "Silver"
        session[:level_id] = 3
      when 'bronze'
        @level = "Bronze"
        @first_benefits = @project.sponsorship_benefits.where(status: true).group_by {|sponsor| sponsor.sponsorship_level_id}[4]
        if (@project.goal.to_i * 0.02) >= 750
          @cost = 750
        else
          @cost = @project.goal.to_i * 0.02
        end
        session[:level_id] = 4
      else
        level_sponsor = @sponsorship_levels.first.id
        @first_benefits = @project.sponsorship_benefits.where(status: true).group_by {|sponsor| sponsor.sponsorship_level_id}[level_sponsor]

        @cost = Sponsor.set_sponsorship_percentage(level_sponsor, @project)
        session[:level_id] = level_sponsor
    end
    @sponsorship_benefits = @project.sponsorship_benefits.where(status: true).group_by {|sponsor| sponsor.sponsorship_level_id}
    render :layout => 'landing'
  end

  def edit
    @sponsor = Sponsor.find(params[:id])
    @project = Project.find(params[:project_id])
    @project_sponsor = ProjectSponsor.unscoped.where(project_id: @project.id, sponsor_id: @sponsor.id).first
    @sponsor.anonymous = @project_sponsor.anonymous
    @sponsorship_benefits = @project.sponsorship_benefits.where(status: true).group_by {|sponsor| sponsor.sponsorship_level_id}
    case @project_sponsor.level_id
      when 1
        @first_benefits = @project.sponsorship_benefits.where(status: true).group_by {|sponsor| sponsor.sponsorship_level_id}[1]
        @cost = @project.goal.to_i * 0.25
        @level = "Platinum"
        session[:level_id] = 1
      when 2
        @first_benefits = @project.sponsorship_benefits.where(status: true).group_by {|sponsor| sponsor.sponsorship_level_id}[2]
        @cost = @project.goal.to_i * 0.1
        @level = "Gold"
        session[:level_id] = 2
      when 3
        @first_benefits = @project.sponsorship_benefits.where(status: true).group_by {|sponsor| sponsor.sponsorship_level_id}[3]
        @cost = @project.goal.to_i * 0.05
        @level = "Silver"
        session[:level_id] = 3
      when 4
        @level = "Bronze"
        @first_benefits = @project.sponsorship_benefits.where(status: true).group_by {|sponsor| sponsor.sponsorship_level_id}[4]
        if (@project.goal.to_i * 0.02) >= 750
          @cost = 750
        else
          @cost = @project.goal.to_i * 0.02
        end
        session[:level_id] = 4
    end
    render :layout => 'landing'
  end

  def update
    params[:project_sponsor][:anonymous] = params[:sponsor][:anonymous]
    params[:sponsor].delete("anonymous")
    @sponsor = Sponsor.find(params[:id])
    @project_sponsor = ProjectSponsor.unscoped.where(project_id: params[:project_id], sponsor_id: @sponsor.id).first
    sponsor = params[:sponsor]
    project = Project.find(params[:project_id])
    sponsor_name = sponsor[:payment_type].eql?("Wire Transfer") ? sponsor[:name] : sponsor[:card_name]

    cost = Sponsor.set_sponsorship_percentage(params[:project_sponsor][:level_id], project)
    params[:sponsor][:name] = sponsor_name
    params[:sponsor][:email] = current_user.email if params[:sponsor][:email].blank?
    @sponsor.update_attributes!(params[:sponsor])
    @project_sponsor.update_attributes!(params[:project_sponsor].merge({cost: cost, project_id: params[:project_id], sponsor_id: @sponsor.id,
                                      level_id: params[:project_sponsor][:level_id]}))
    redirect_to confirmation_url(params[:project_id], @sponsor.id)
  end

  def create
    # current_user = :current_user
    project = Project.find(params[:project_id])
    logger.debug "Project is #{project}"
    sponsor_count = project.project_sponsors.where(level_id: params[:project_sponsor][:level_id]).count
    case params[:project_sponsor][:level_id]
    when '1'
      if sponsor_count < 1
        create_sponsor
      else
        failed_create_sponsor
      end
    when '2'
      if sponsor_count < 3
        create_sponsor
      else
        failed_create_sponsor
      end
    when '3'
      if sponsor_count < 5
        create_sponsor
      else
        failed_create_sponsor
      end
    when '4'
      create_sponsor
    end
  end

  def get_sponsorship_levels
    project = Project.find(params[:project_id])
    @sponsorship_level = SponsorshipLevel.find(params[:sponsor_id])
    @benefits = project.sponsorship_benefits.where(status: true, sponsorship_level_id: params[:sponsor_id])

    case params[:sponsor_id]
    when "1"
      @cost = project.goal.to_i * 0.25
      @image = "/assets/platinum-placement.png"
    when "2"
      @cost = project.goal.to_i * 0.1
      @image = "/assets/gold-placement.png"
    when "3"
      @cost = project.goal.to_i * 0.05
      @image = "/assets/silver-placement.png"
    when "4"
      @image = "/assets/bronze-placement.png"
      if project.goal.to_i * 0.02 >= 750
        @cost = 750
      else
        @cost = project.goal.to_i * 0.02
      end
    end

    respond_to :js
  end

  def confirmation
    @sponsor = Sponsor.find(params[:id])
    @project_sponsor =   ProjectSponsor.unscoped.where(project_id: @project.id, sponsor_id: @sponsor.id).first
    @benefits = @project.sponsorship_benefits.where(status: true, sponsorship_level_id: @project_sponsor.level_id )
    @sponsorship_level = SponsorshipLevel.find(@project_sponsor.level_id)
    @cost = Sponsor.set_sponsorship_percentage(@project_sponsor.level_id.to_s, @project)
  end

  def thank_you
    @project = Project.find(params[:project_id])
    project_sponsor =  ProjectSponsor.unscoped.where(project_id: @project.id, sponsor_id: params[:sponsor_id]).first
    @project_sponsor = project_sponsor
    Sponsor.save_customer(current_user, @project_sponsor)
    sponsor = Sponsor.find(params[:sponsor_id])
    # Sponsor.create_charge(@project_sponsor)
    # @sponsorship_level = SponsorshipLevel.find(project_sponsor.level_id)
    @benefits = @project.sponsorship_benefits.where(status: true, sponsorship_level_id: project_sponsor.level_id )
    case project_sponsor.level_id
    when 1
      @cost = @project.goal.to_i * 0.25
      @level = "Platinum"
    when 2
      @cost = @project.goal.to_i * 0.1
      @level = "Gold"
    when 3
      @cost = @project.goal.to_i * 0.05
      @level = "Silver"
    when 4
      if @project.goal.to_i * 0.02 >= 750
        @cost = 750
      else
        @cost = @project.goal.to_i * 0.02
      end
      @level = "Bronze"
    end
    @need_doctype = true
  end

  def confirm_sponsor
    @sponsor = Sponsor.find(params[:sponsor_id])
    project_sponsor = ProjectSponsor.unscoped.where(project_id: params[:project_id], sponsor_id: @sponsor.id).last
    project_sponsor.update_attributes!(status: "confirmed", confirmed: true)
    Sponsor.delay.send_confirmation_email(@sponsor)
    Sponsor.delay.sponsor_thank_you(@sponsor.id, @sponsor.email)
    redirect_to thank_you_for_sponsor_url(params[:project_id], @sponsor.id)
  end

  def share_email
    SponsorMailer.share_project(params[:emails], params[:project_id], params[:user]).deliver
    respond_to :js { render :layout => false }
  end

  private

  def project_id
    @project = Project.find(params[:project_id])
    @sponsorship_levels = SponsorshipLevel.all
    sponsors_of_project = @project.project_sponsors
    platinum = sponsors_of_project.select { |sponsor| sponsor.level_id.eql?(1) }.count
    gold = sponsors_of_project.select { |sponsor| sponsor.level_id.eql?(2) }.count
    silver = sponsors_of_project.select { |sponsor| sponsor.level_id.eql?(3) }.count
    @sponsorship_levels.delete_if{|level| level.name.eql?("Platinum")} if platinum >= 1
    @sponsorship_levels.delete_if{|level| level.name.eql?("Gold")} if gold >= 3
    @sponsorship_levels.delete_if{|level| level.name.eql?("Silver")} if silver >= 5
  end

  def create_sponsor
    params[:project_sponsor][:anonymous] = params[:sponsor][:anonymous]
    params[:sponsor].delete("anonymous")
    sponsor = params[:sponsor]
    sponsor_name = sponsor[:payment_type].eql?("Wire Transfer") ? sponsor[:name] : sponsor[:card_name]
    project = Project.find(params[:project_id])

    cost = Sponsor.set_sponsorship_percentage(params[:project_sponsor][:level_id], project)
    params[:sponsor][:name] = sponsor_name
    card_type = params[:project_sponsor][:card_type]
    last4 = params[:project_sponsor][:card_last4]
    token = params[:token]
    @sponsor = Sponsor.new(params[:sponsor])
    @sponsor.email = current_user.email if params[:sponsor][:email].blank?
    @sponsor.save!(validate: false)
    @project_sponsor = ProjectSponsor.create!(params[:project_sponsor])
    @project_sponsor.confirmed = false
    @project_sponsor.save!
    @project_sponsor.update_attributes!({cost: cost, project_id: params[:project_id], sponsor_id: @sponsor.id,
                                      level_id: params[:project_sponsor][:level_id], card_token: token,
                                      card_type: card_type, card_last4: last4, sponsor_type: params[:type] })
    session[:project_sponsor] = @project_sponsor
    # Sponsor.delay.send_confirmation_email(@sponsor)
    # Sponsor.delay.sponsor_thank_you(@sponsor.id, @sponsor.email)
    redirect_to confirmation_url(params[:project_id], @sponsor.id)
  end

  def failed_create_sponsor
    redirect_to :back
  end
end
