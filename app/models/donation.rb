class Donation < ActiveRecord::Base
  attr_accessible :amount, :project_id, :customer_token, :user_id, :email, :token,
  :card_last4, :created_at, :card_type, :perk_name, :confirmed, :description, :anonymous, :last_founded
  attr_accessor :token, :card_last4, :card_type, :type_founder

  belongs_to :project
  belongs_to :user

  default_scope { where(confirmed: true) }

  def save_with_payment
    current_user = :current_user
    Stripe.api_key = "#{Settings.stripe.api_key}"
    customer = Stripe::Customer.create(description: email, card: token)
    self.customer_token = customer.id
    self.confirmed = true
    save!

  rescue Stripe::InvalidRequestError => e
    logger.error "Stripe error while creating customer: #{e.message}"
    errors.add :base, "There was a problem with your credit card."
    false
  end

  def self.reorder_perks(perks, amount)
    perks_arr = []

    perks.each do |perk|
      if perk[1].to_f <= amount
        if !perk[4].blank? && perk[4].to_i > 0
          perks_arr.push(perk)
        elsif perk[4].blank?
          perks_arr.push(perk)
        end
      end
    end

    perks_arr

  end

  def self.get_perk_info(project, amount, perks)

    if !project.perk_permission
      perk_description = "#{amount.to_i} Uruut Reward Points"
      arr = AMOUNTS.each do |a|
        a < amount
      end

      if arr[0] == nil || arr[0] == ''
        perk_name_selected = "Custom"
      else
        perk_name_selected = LEVELS[AMOUNTS.index(arr[0].max)]
      end

    elsif perks.blank?
      perk_name_selected = "No Perk"
      perk_description = ""
    else
      perk_name_selected = perks.last[0]
      perk_description = perks.last[3]
    end

    return [perk_name_selected, perk_description]
  end

  def self.set_perk_id(perks, project)
    if perks.blank?
      perk_id = "Custom"
    elsif project.perk_permission
      perk_id = perks.last[2]
    else
      perk_id = perks.last[0]
    end
    perk_id
  end

  def self.set_perks(project)
    if project.perk_permission
      perks = project.perks.order(:amount).map{ |perk| [perk.name, perk.amount.to_i, perk.id, perk.description, perk.perks_available] }
    else
      perks = DEFAULT_PERK
    end
    perks
  end

  ###  new function for handle Stripe error  ###

  def error_payment?
    error = false
    Stripe.api_key = "#{Settings.stripe.api_key}"
    begin
      customer = Stripe::Customer.create(description: email, card: token)
    rescue Stripe::CardError => e
      error = e.message
    end
    error
  end

  #####################################################

  def self.already_donated(project, user)
  	@donation = Donation.where("project_id = ? AND user_id = ?", project, user)
  	if @donation.length == 0
  		return nil
  	else
  		return @donation.first.amount
  	end
  end

  def self.edit_donation(project, user)
  	@donation = Donation.where("project_id = ? AND user_id = ?", project, user)
  	return @donation.first.id
  end

  def self.send_confirmation_email(donation)
    DonationMailer.donation_confirmation(donation).deliver
  end

  def self.generate_report(project_id)
    require 'csv'

    project = Project.find(project_id)
    project_name = project.project_title
    index_array = project.donations.map(&:user_id).uniq
    donations = project.donations

    perks = project.perks.order("id ASC")

    CSV.open("#{Rails.root}/reports/donor_report.csv", "w+") do |csv|

      csv << ["project name", "email", "first name", "last name", "amount", "perk", "description"]

      index_array.each do |index|
        sum = 0
        matches = donations.where("user_id = ?",index)
        matches.each do |p|
          sum += p.amount
        end

        if perks.first.amount > sum
          perk_name = "n/a"
          perk_description = "n/a"
        elsif sum > perks.last.amount
          perk_name = perks.last.name
          perk_description = perks.last.description
        else
          perks.each do |p|
            if p.amount < sum
              perk_name = p.name
              perk_description = p.description
            end
          end
        end

        csv << ["#{project_name}", "#{matches.uniq.first.email}", "#{User.find(matches.uniq.first.user_id).first_name}", "#{User.find(matches.uniq.first.user_id).last_name}", "#{sum}", "#{perk_name}", "#{perk_description}"]
      end

    end

    DonationMailer.send_donation_report.deliver

  end

end
