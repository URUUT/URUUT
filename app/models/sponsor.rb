class Sponsor < ActiveRecord::Base
  PAYMENT = ["Credit Card", "Wire Transfer/Check"]
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :name, :payment_type,
                  :phone, :org_name, :mission, :card_name

  attr_accessor :card_name, :anonymous
  # attr_accessible :title, :body
  has_many :project_sponsors

  validates :card_name, presence: true, if: :payment_type_credit_card?
  validates :phone, :email, :name, presence: true, if: :payment_type_transfer?

  def payment_type_transfer?
    self.payment_type.eql? "Wire Transfer"
  end

  def payment_type_credit_card?
    self.payment_type.eql? "Credit Card"
  end

  def self.send_confirmation_email(sponsor)
    SponsorMailer.new_sponsor(sponsor).deliver
  end

  def self.sponsor_thank_you(sponsor, email)
    SponsorMailer.sponsor_thank_you(sponsor, email).deliver
  end

  def self.save_customer(current_user, project_sponsor)
    Stripe.api_key = "#{Settings.stripe.api_key}"
    name = current_user.first_name + ' ' + current_user.last_name
    description = "Name: #{name}, Email: #{current_user.email}, Payment Type: Sponsor"
    customer = Stripe::Customer.create(description: description, card: project_sponsor.card_token)
    project_sponsor.customer_id = customer.id
    project_sponsor.save!

  rescue Stripe::InvalidRequestError => e
    logger.error "Stripe error while creating customer: #{e.message}"
    # errors.add :base, "There was a problem with your credit card."
    false
  end

  def self.create_charge(project_sponsor)
    Stripe.api_key = "#{Settings.stripe.api_key}"
    customer = project_sponsor.customer_id
    auth_token = Project.find(project_sponsor.project_id).project_token
    logger.debug customer

    token = Stripe::Token.create(
      {:customer => customer},
      auth_token # user's access token from the Stripe Connect flow
    )

    Stripe::Charge.create({
        :amount => 1000, # in cents
        :currency => "usd",
        :token => token,
        :application_fee => 1000
    }, auth_token)

  rescue Stripe::InvalidRequestError => e
    logger.error "Stripe error while creating customer: #{e.message}"
    # errors.add :base, "There was a problem with your credit card."
    false
  end

  def self.generate_report(project_id)
    require 'csv'

    project_name = Project.find(project_id).project_title
    index_array = ProjectSponsor.where("project_id = ?", project_id).map(&:sponsor_id).uniq
    benefit = SponsorshipBenefit.where("project_id = ?", project_id).order("id ASC")

    CSV.open("#{Rails.root}/reports/sponsor_report.csv", "w+") do |csv|
      csv << ["project name", "email", "sponsor name", "amount", "benefits"]

      index_array.each do |index|
        sum = 0
        less_than_sum = []

        matches = ProjectSponsor.where("project_id = ? AND sponsor_id = ?", project_id, index)
        matches.each do |m|
          sum += m.cost
        end
        puts sum

        benefit.each do |b|
          if b.cost > sum
            less_than_sum.push b
          end
        end

        level_cost = less_than_sum.max

        total_benefits = less_than_sum.each_index.select{|i| less_than_sum[i].cost == level_cost.cost}
        benefit_names = ''

        total_benefits.each do |tb|
          puts less_than_sum[tb].name
        end
        puts Sponsor.find(index).name
        puts benefit_names

        csv << ["#{project_name}", "#{Sponsor.find(matches.uniq.first.id).email}", "#{Sponsor.find(matches.uniq.first.id).name}", "#{sum}", "#{benefit_names}"]
      end
    end

    SponsorMailer.send_sponsor_report.deliver

  end

end
