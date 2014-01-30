class Demo < ActiveRecord::Base

  NON_PROFIT = HashWithIndifferentAccess.new({
    yes: 1,
    no: 0
    })

  BASIC_OPTIONS = HashWithIndifferentAccess.new({
    yes: 1,
    no: 0,
    'I don’t know' => 3
    })

  CROWDFUNDING_CAMPING = HashWithIndifferentAccess.new({
    yes: 1,
    no: 0,
    'Not applicable' => 3
    })

  TYPE_OF_ACCEPTED_DONATIONS = HashWithIndifferentAccess.new({
    donate_now: [0, 'We accept online donations using a “Donate Now” button and payment processing system (e.g. “PayPal”)'],
    software_solution: [1, 'We accept online donations using a software solution(e.g. CommonGround, Blackbaud, Sage)'],
    not_accept: [2, 'We do not currently accept online donations, but would like to!']
    })

  CROWDFUNDING = HashWithIndifferentAccess.new({
    actively_engaged: [0, 'We are actively engaged in a crowdfunding campaign now.'],
    engaged: [1, 'We have engaged in a crowdfunding campaign in the past.'],
    not_engaged: [2, 'We have not engaged in crowdfunding yet.']
    })

  SOCIAL_OUTREACH = HashWithIndifferentAccess.new({
    pro_active: [0, 'We are pro-active in social media, and have the right resources in to manage donor outreach through our social media properties.'],
    active: [1, 'We are active in social media, but do not have a proactive strategy.'],
    not_active: [2, 'We are more reactive in social media, than proactive.'],
    reactive: [3, 'We are not active in social media, but would like to be.']
    })

  MONEY_RAISED_YEARLY = HashWithIndifferentAccess.new({
    'Under $50K' =>    1,
    '$50K – $100K' =>  2,
    '$100K – $250K' => 3,
    '$250K – $500K' => 4,
    '$500K – $1M' =>   5,
    '$1M – $3M' =>     6,
    '$3M – $5M' =>     7,
    'Over $5M' =>      8
    })

  CURRENT_FUNDRAISING_ACTIVITIES = HashWithIndifferentAccess.new({
    fund_events: 'Events',
    fund_website_donation: 'Donate on website',
    fund_direct_email: 'Direct Mail',
    fund_email: 'Email',
    fund_year_round: 'Year-round fundraising',
    fund_seasonal: 'Seasonal fundraising',
    fund_other: 'Other:'
    })

  TYPE_OF_DONORS_ACCEPTED = HashWithIndifferentAccess.new({
    accepts_donations_from_individual: 'Individuals',
    accepts_donations_from_foundations: 'Foundations',
    accepts_donations_from_businesses: 'Businesses',
    accepts_donations_from_other: 'Other:',
    })

  attr_accessible :accepts_donations_from_businesses,
    :accepts_donations_from_foundations,
    :accepts_donations_from_individual,
    :accepts_donations_from_other,
    :accepts_donations_from_other_description,
    :crowdfunding,
    :crowdfunding_campaign_goals,
    :email,
    :first_name,
    :founded_date,
    :fund_direct_email,
    :fund_email,
    :fund_events,
    :fund_other,
    :fund_other_description,
    :fund_seasonal,
    :fund_website_donation,
    :fund_year_round,
    :last_name,
    :money_raised_yearly,
    :non_profit,
    :organization,
    :organization_description,
    :phone,
    :seven_days_to_receive_funds,
    :social_outreach,
    :sponsorship_program,
    :type_of_accepted_donations

  validates :first_name, :last_name, :organization, :email, :phone,
    :founded_date, :non_profit, :organization_description, :money_raised_yearly,
    :sponsorship_program, :crowdfunding, :crowdfunding_campaign_goals,
    :seven_days_to_receive_funds, :social_outreach, presence: true

  validate :current_fundraising_activities, :type_of_accepted_donors

private

  def current_fundraising_activities
    unless valid_fundraising_activities_options?
      errors.add(:base, 'You must select at least one fundraising activity')
    end
  end

  def valid_fundraising_activities_options?
    (fund_direct_email     ||
     fund_email            ||
     fund_events           ||
     fund_seasonal         ||
     fund_website_donation ||
     fund_year_round)      ||
    (fund_other            &&
     fund_other_description.present?)
  end

  def type_of_accepted_donors
    unless valid_type_of_donors?
      errors.add(:base, 'You must select at least kind of donor your organization accepts')
    end
  end

  def valid_type_of_donors?
    (accepts_donations_from_businesses  ||
     accepts_donations_from_foundations ||
     accepts_donations_from_individual) ||
    (accepts_donations_from_other &&
     accepts_donations_from_other_description.present?)
  end

end
