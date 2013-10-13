class Donation < ActiveRecord::Base
  attr_accessible :amount, :project_id, :customer_token, :user_id, :email, :token,
  :card_last4, :created_at, :card_type, :perk_name, :confirmed, :description, :anonymous
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

    project_name = Project.find(project_id).project_title
    index_array = Donation.where("project_id = ?", project_id).map(&:user_id).uniq
    donations = Donation.where("project_id = ?", project_id)
    perks = Perk.where("project_id = ?", project_id).order("id DESC")

    CSV.open("#{Rails.root}/reports/report.csv", "w+") do |csv|

      csv << ["project name", "email", "amount", "perk", "description"]

      index_array.each do |index|
        sum = 0
        matches = donations.where("user_id = ?",index)
        matches.each do |p|
          sum += p.amount
        end

        if perks.first.amount > sum
          puts "sum is too small for perk"
          perk_name = "n/a"
          perk_description = "n/a"
        elsif sum > perks.last.amount
          puts "sum gets largest perk"
          perk_name = perks.last.name
          perk_description = perks.last.description
        else
          p = perks.bsearch {|x| x.amount < sum}
          puts "#{p.name} #{p.amount}"
          # perks.each_cons(3) do |p, c, n|
          #   if sum.between?(p.amount, n.amount)
          #     puts "sum is between before and after"
          #     if sum = p.amount
          #       puts "sum = before"
          #       perk_name = p.name
          #       perk_description = p.description
          #     elsif sum = n.amount
          #       puts "sum = after"
          #       perk_name = n.name
          #       perk_description = n.description
          #     else
          #       puts "sum <> so still looking"
          #       perk_name = p.name
          #       perk_description = p.description
          #     end
          #   end
          # end
        end

        csv << ["#{project_name}", "#{matches.uniq.first.email}", "#{sum}", "#{perk_name}", "#{perk_description}"]
      end

    end

    DonationMailer.send_donation_report.deliver

  end

end
