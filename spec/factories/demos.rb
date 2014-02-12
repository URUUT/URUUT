# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :demo do
    first_name "MyString"
    last_name "MyString"
    organization "MyString"
    email "MyString"
    phone "MyString"
    founded_date "2014-01-29"
    non_profit 1
    organization_description "MyText"
    money_raised_yearly 1
    fund_events false
    fund_website_donation false
    fund_direct_email false
    fund_email false
    fund_year_round false
    fund_seasonal false
    fund_other false
    fund_other_description "MyString"
    type_of_accepted_donations 1
    accepts_donations_from_individual false
    accepts_donations_from_businesses false
    accepts_donations_from_foundations false
    accepts_donations_from_other false
    accepts_donations_from_other_description "MyString"
    sponsorship_program 1
    crowdfunding 1
    crowdfunding_campaign_goals 1
    seven_days_to_receive_funds 1
    social_outreach "MyString"
  end
end
