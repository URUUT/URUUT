class SponsorsController < ApplicationController

  before_filter :project_id, except: [:thank_you, :share_email]

  skip_before_filter :session_email_forgot_password, only: [:share_email]

  def new
    @sponsor = Sponsor.new
    @sponsor.anonymous = false
    @project = Project.find(params[:project_id])
    @is_sponsor = true
    @is_donor = false
    session[:path] = "sponsor_new"
    case params[:level]
      when 'platinum'
        @first_benefits = @project.sponsorship_benefits.where(status: true).group_by {|sponsor| sponsor.sponsorship_level_id}[@project_levels[1].id]
        @cost = @project_levels[1].calculated_cost(@project)
        @level = @project_levels[1].name || "Platinum"
        session[:level_id] = @project_levels[1].id || 1
        @parent_id = @project_levels[1].parent_id || 1
      when 'gold'
        @first_benefits = @project.sponsorship_benefits.where(status: true).group_by {|sponsor| sponsor.sponsorship_level_id}[@project_levels[2].id]
        @cost = @project_levels[2].calculated_cost(@project)
        @level = @project_levels[2].name || "Gold"
        session[:level_id] = @project_levels[2].id || 2
        @parent_id = @project_levels[2].parent_id || 2
      when 'silver'
        @first_benefits = @project.sponsorship_benefits.where(status: true).group_by {|sponsor| sponsor.sponsorship_level_id}[@project_levels[3].id]
        @cost = @project_levels[3].calculated_cost(@project)
        @level = @project_levels[3].name || "Silver"
        session[:level_id] = @project_levels[3].id || 3
        @parent_id = @project_levels[3].parent_id || 3
      when 'bronze'
        @level = @project_levels[4].name || "Bronze"
        @first_benefits = @project.sponsorship_benefits.where(status: true).group_by {|sponsor| sponsor.sponsorship_level_id}[@project_levels[4].id]
        @cost = @project_levels[4].calculated_cost(@project)
        session[:level_id] = @project_levels[4].id || 4
        @parent_id = @project_levels[4].id || 4
      else
        level_sponsor = @project_levels[1].id
        @level = @project_levels[1].name || "Platinum"
        @first_benefits = @project.sponsorship_benefits.where(status: true).group_by {|sponsor| sponsor.sponsorship_level_id}[level_sponsor]

        @cost = Sponsor.set_sponsorship_percentage(level_sponsor, @project)
        session[:level_id] = level_sponsor
        @parent_id = 1
    end
    @sponsorship_benefits = @project.sponsorship_benefits.where(status: true).group_by {|sponsor| sponsor.sponsorship_level_id}
    session[:redirect_url] = request.url
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
    session.delete(:redirect_url)
    project = Project.find(params[:project_id])
    logger.debug "Project is #{project}"
    if Sponsor.can_be_created?(params[:project_sponsor][:level_id], project)
      create_sponsor_and_user
    else
      failed_create_sponsor
    end
  end

  def get_sponsorship_levels
    project = Project.find(params[:project_id])
    @sponsorship_level = SponsorshipLevel.find(params[:sponsor_id])
    @benefits = project.sponsorship_benefits.where(status: true, sponsorship_level_id: params[:sponsor_id])

    @cost = @sponsorship_level.calculated_cost(@project)
    case @sponsorship_level.parent_id
    when 1
      @image = "/assets/platinum-placement.png"
    when 2
      @image = "/assets/gold-placement.png"
    when 3
      @image = "/assets/silver-placement.png"
    when 4
      @image = "/assets/bronze-placement.png"
    end

    respond_to :js
  end

  def confirmation
    @sponsor = Sponsor.find(params[:id])
    @project_sponsor =   ProjectSponsor.unscoped.where(project_id: @project.id, sponsor_id: @sponsor.id).first
    @benefits = @project.sponsorship_benefits.where(status: true, sponsorship_level_id: @project_sponsor.level_id )
    @sponsorship_level = SponsorshipLevel.find(@project_sponsor.level_id)
    @cost =  @sponsorship_level.calculated_cost(@project)
  end

  def thank_you
    @project = Project.find(params[:project_id])
    project_sponsor =  ProjectSponsor.unscoped.where(project_id: @project.id, sponsor_id: params[:sponsor_id]).first
    @project_sponsor = project_sponsor
    Sponsor.save_customer(current_user, @project_sponsor)
    # Sponsor.create_charge(@project_sponsor)
    # @sponsorship_level = SponsorshipLevel.find(project_sponsor.level_id)
    @benefits = @project.sponsorship_benefits.where(status: true, sponsorship_level_id: project_sponsor.level_id )
    @level = project_sponsor.sponsorship_level.name
    @cost = project_sponsor.sponsorship_level.calculated_cost(@project)
    @need_doctype = true
  end

  def confirm_sponsor
    @sponsor = Sponsor.find(params[:sponsor_id])
    project_sponsor = ProjectSponsor.unscoped.where(project_id: params[:project_id], sponsor_id: @sponsor.id).last
    project_sponsor.update_attributes!(status: "confirmed", confirmed: true)
    SponsorMailer.delay.new_sponsor(@sponsor)
    SponsorMailer.delay.sponsor_thank_you(@sponsor.id, @sponsor.email)
    redirect_to thank_you_for_sponsor_url(params[:project_id], @sponsor.id)
  end

  def share_email
    SponsorMailer.share_project(params[:emails], params[:project_id], params[:user]).deliver
    respond_to :js
  end

  private

  def project_id
    @project = Project.find(params[:project_id])
    @project_levels = SponsorshipLevel.with_benefits(@project)
  end

  def create_sponsor_and_user
    create_user(params[:user]) unless current_user
    params[:project_sponsor][:anonymous] = params[:sponsor][:anonymous]
    params[:sponsor].delete("anonymous")
    sponsor = params[:sponsor]
    sponsor_name = sponsor[:payment_type].eql?("Wire Transfer") ? sponsor[:name] : sponsor[:card_name]
    project = Project.find(params[:project_id])
    level = SponsorshipLevel.find(params[:project_sponsor][:level_id])
    cost = level.calculated_cost(project)
    params[:sponsor][:name] = sponsor_name
    card_type = params[:project_sponsor][:card_type]
    last4 = params[:project_sponsor][:card_last4]
    token = params[:token]
    @sponsor = Sponsor.new(params[:sponsor])
    @sponsor.email = (current_user && params[:sponsor][:email].blank?)? current_user.email : params[:sponsor][:email]
    @project_sponsor = ProjectSponsor.create!(params[:project_sponsor])
    @project_sponsor.confirmed = false

    if @sponsor.save!(validate: false) && @project_sponsor.save! && current_user
      @project_sponsor.update_attributes!({cost: cost, project_id: params[:project_id], sponsor_id: @sponsor.id,
                                        level_id: params[:project_sponsor][:level_id], card_token: token,
                                        card_type: card_type, card_last4: last4, sponsor_type: params[:type] })
      session[:project_sponsor] = @project_sponsor
      redirect_to confirmation_url(params[:project_id], @sponsor.id)
    else
      level_sponsor = level.id
      @level = level.name
      @first_benefits = @project.sponsorship_benefits.where(status: true).group_by {|sponsor| sponsor.sponsorship_level_id}[level_sponsor]

      @cost = Sponsor.set_sponsorship_percentage(level_sponsor, @project)
      session[:level_id] = level_sponsor
      @parent_id = level.id
      @sponsorship_benefits = @project.sponsorship_benefits.where(status: true).group_by {|sponsor| sponsor.sponsorship_level_id}
      render :new, :layout => 'landing'
    end
  end

  def failed_create_sponsor
    redirect_to :back
  end

  private

  def create_user(user_params)
    return nil unless user_params
    @user = User.new(user_params)
    if @user.save
      @user.build_membership.save
      Gateway::CustomerService.new(@user).create
      Gateway::PlansService.new(@user).update_plan('fee') if @user.sign_up_plan == 'fee'
      sign_in(:user, @user)
    end
    @user
  end
end
