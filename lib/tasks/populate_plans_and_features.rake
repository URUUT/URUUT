namespace :populate do
  desc 'Creates plans and features'
  task plans_and_features: :environment do

    FEE_FEATURES = {
      multidonor: 'Multi-donor Social Fundraising Platform',
      stripe_payments: 'Uruut Payments Powered by Stripe',
      all_or_nothing: 'All or Nothing Funding Engine',
      realtime_analytics: 'Realtime Campaign Analytics',
      marketplace: 'Uruut.com Marketplace',
      campaign_wizzard: 'Easy to Use Campaign Setup Wizard',
      social_analytics: 'Campaign Social Analytics',
      unlimited_projects: 'Unlimited Projects',
      donor_cms: 'Basic Donor Management / CRM',
      oureach_platform: 'Social and Email Outreach Platform',
      email_support: 'Unlimited Email Support',
      communication_center: 'Post Funding Communication Center',
      cancel_anytime: 'Total Flexibility Cancel Anytime*'
    }

    BASIC_FEATURES = FEE_FEATURES.merge({
      no_transaction_fee: 'No Transaction Fee^'
    })

    PLUS_FEATURES = BASIC_FEATURES.merge({
      partial_funding: 'All or Nothing AND Partial Funding',
      auto_tax: 'Auto Tax Letter Generation',
      volunteer_tracker: 'Volunteer Solicitation Tracker',
      google_seo: 'Free Google SEO Grant Application',
      custom_sponsors: 'Custom Sponsors'
    })

    # Creates all features
    PLUS_FEATURES.each do |name, description|
      feature = Feature.new(name: name.to_s, description: description).save
    end

    # Creates fee plan and it features
    fee_plan = Plan.new(name: 'fee')
    fee_plan.save
    fee_plan_features = Feature.where(name: FEE_FEATURES.keys.map(&:to_s))
    fee_plan.features << fee_plan_features

    # Creates basic plan and it features
    basic_plan = Plan.new(name: 'basic', stripe_plan_id: 'basic')
    basic_plan.save
    basic_plan_features = Feature.where(name: BASIC_FEATURES.keys.map(&:to_s))
    basic_plan.features << basic_plan_features

    # Creates plus plan and it features
    plus_plan = Plan.new(name: 'plus', stripe_plan_id: 'plus')
    plus_plan.save
    plus_plan_features = Feature.where(name: PLUS_FEATURES.keys.map(&:to_s))
    plus_plan.features << plus_plan_features
  end
end
