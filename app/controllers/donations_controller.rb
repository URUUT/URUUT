class DonationsController < ApplicationController
  skip_before_filter :verify_authenticity_token, only: :default_perk
	before_filter :authenticate_user!
  before_filter :set_session_page, :set_session_wizard
  layout "landing"

	def new
		@donation = Donation.new
    @perk = Perk.find(params[:perk])
    @perk_name = params[:name].to_s
    @perk_amount = params[:amount].gsub(",", "").to_i
    @perk_description = params[:description]
    @project = Project.find(params[:project_id])
    @perks = @project.perks.order(:amount).map{ |perk| [perk.name, perk.amount.to_i] }
    session[:perk_id] = params[:perk]
	end

  def default_perk
    @donation = Donation.new
    @perk = Perk.new
    @perk_name = params[:name].to_s
    @perk_amount = params[:amount].gsub(",", "").gsub(/[^\d,]+/, '').to_i
    @perk_description = params[:description]
    @project = Project.find(params[:project_id])
    if params[:amount].blank?
      @perks = @project.perks.order(:amount).map{ |perk| [perk.name, perk.amount.to_i] }
      session[:perk_id] = "custom_donate"
    else
      if @project.perk_permission
        perks = @project.perks.order(:amount).map{ |perk| [perk.name, perk.amount.to_i, perk.id] }
      else
        perks = DEFAULT_PERK
      end
      @perks = []
      perks.each do |perk|
        if perk[1].to_f <= params[:amount].gsub(",", "").to_f
          @perks.push(perk)
        end
      end
      if @perks.blank?
        @perk_name_selected = "Custom"
      else
        @perk_name_selected = @perks.last[0]
      end

      if @perks.blank?
        session[:perk_id] = "Custom"
      elsif @project.perk_permission
        session[:perk_id] = @perks.last[2]
      else
        session[:perk_id] = @perks.last[0]
      end
    end
    render :new
  end

  def change_perk
    if !params[:id].eql?("custom")
      if params["amount"].blank?
        @perk = Perk.find(params[:id])
        @project = Project.find(params["project_id"])
        session[:perk_id] = @perk.id
        session[:perk_amount] = @perk.amount.to_f
      else
        @perk = Perk.new
        @perk.id = params["level"]
        @perk.amount = params["amount"].gsub(",", "")
        session[:perk_amount] = @perk.amount.to_f
        @project = Project.find(params["project_id"])
        if @project.perk_permission
          perks = @project.perks.order(:amount).map{ |perk| [perk.name, perk.amount.to_i, perk.id] }
        else
          perks = DEFAULT_PERK
        end
        @perks = []
        perks.each do |perk|
          if perk[1].to_f <= params["amount"].gsub(",", "").to_f
            @perks.push(perk)
          end
        end
        @perk_name_selected = @perks.last[0]
        if @project.perk_permission
          session[:perk_id] = @perks.last[2]
        else
          session[:perk_id] = @perks.last[0]
        end
        @perk.name = "LEVEL #{@perk.id}"
        @perk.description = "You will receive #{@perk.amount.to_i} Uruut Reward Points when you seed $#{@perk.amount.to_i}"
      end
    else
      @perk = Perk.new
      @perk.id = params["level"]
      @perk.amount = params["custom_seed"].gsub(",", "")
      @project = Project.find(params["project_id"])
      if @project.perk_permission
        perks = @project.perks.order(:amount).map{ |perk| [perk.name, perk.amount.to_i, perk.id] }
      else
        perks = DEFAULT_PERK
      end
      @perks = []
      perks.each do |perk|
        if perk[1].to_f <= params["custom_seed"].gsub(",", "").to_f
          @perks.push(perk)
        end
      end
      if @perks.blank?
        @perk_name_selected = "Custom"
      else
        @perk_name_selected = @perks.last[0]
      end

      if @perks.blank?
        session[:perk_id] = "Custom"
      elsif @project.perk_permission
        session[:perk_id] = @perks.last[2]
      else
        session[:perk_id] = @perks.last[0]
      end
      session[:perk_amount] = @perk.amount.to_f
      @perk.name = "Custom"
      @perk.description = "You will receive #{@perk.amount} Uruut Reward Points when you seed $#{@perk.amount}"
    end
  end

	def create
    params[:donation][:perk_name] = params[:name_of_perk]
    @donation = Donation.new(params[:donation])
    @donation.confirmed = false

    if @donation.save
      session.merge!(:donation_id => @donation.id, :card_token => @donation.token, :card_type => @donation.card_type,
        :card_last4 => @donation.card_last4)
      session[:perk_type] = params[:perk_type]
      session[:payment_amount] = params[:donation][:amount]
      session[:project_id_of_perk_selected] = params[:donation][:project_id]
      session[:perk_amount] = params[:donation][:amount]
      redirect_to donation_steps_path
    else
      render :new
    end

    #@donation = Donation.new(params[:donation])
    #@token = @donation.token
    #if @donation.save_with_payment
    #  redirect_to project_url(@donation.project_id), :notice => "Thank you for contributing!"
    #else
    #  render :new
    #end
	end

	def edit
		@donation = Donation.unscoped.find(params[:id])
    @project = @donation.project
    perks = @project.perks.order(:amount).map{ |perk| [perk.name, perk.amount.to_i, perk.id] }
    @perks = []
    perks.each do |perk|
      if perk[1].to_f <= @donation.amount.to_f
        @perks.push(perk)
      end
    end
    if @perks.blank?
      @perk_name_selected = "Custom"
    else
      @perk_name_selected = @perks.last[0]
		end
    @donation.save!
	end

  def set_new_perk
    perk = Perk.where(name: params[:name_of_perk], project_id: params[:project_id])
    if perk.empty?
      session[:perk_id] = params[:name_of_perk]
    else
      session[:perk_id] = perk.first.id
    end
    render nothing: true
  end

	def update
		@donation = Donation.unscoped.find(params[:id])
    session[:card_last4] = params[:donation][:card_last4]
    session[:card_type] = params[:donation][:card_type]
    params[:donation][:perk_name] = params[:name_of_perk]
    params[:donation][:amount] = session[:perk_amount]
    # unit = params[:donation][:amount].last
    # case unit
    #   when "K"
    #     params[:donation][:amount] = params[:donation][:amount].to_i * 1000
    #   when "M"
    #     params[:donation][:amount] = params[:donation][:amount].to_i * 1000000
    #   when "B"
    #     params[:donation][:amount] = params[:donation][:amount].to_i * 1000000000
    #   when "T"
    #     params[:donation][:amount] = params[:donation][:amount].to_i * 1000000000000
    #   when "Q"
    #     params[:donation][:amount] = params[:donation][:amount].to_i * 1000000000000000
    # end
    session[:payment_amount] = params[:donation][:amount]
    current_user.update_attributes(uruut_point: session[:payment_amount])
    if params[:donation][:amount].is_a?(String)
      params[:donation][:amount] = params[:donation][:amount].gsub('$', '').gsub(',', '').to_f
		end
    if @donation.update_attributes(params[:donation])
			flash[:notice] = "Successfully updated donation."
		end
		redirect_to donation_steps_path
	end

  def more_donators
    @donators = Donation.where(project_id: params[:id])
  end

  private

  def set_session_page
    session[:page_active] = "project"
  end

end
