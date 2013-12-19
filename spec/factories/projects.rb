# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :project do
    title                        { Faker::Product.product_name }
    description                  { Faker::Lorem.paragraph(3) }
    duration                     "75"
    goal                         "1000"
    category                     "Walkability / Bike / Paths"
    association                  :user
    address                      { Faker::Address.street_address }
    city                         { Faker::Address.city }
    state                        { Faker::Address.us_state_abbr }
    zip                          { Faker::Address.zip_code }
    live                         1
    short_description            { Faker::Lorem.paragraph(1) }
    bitly                        { Faker::Internet.http_url }
    project_token                { Faker::Lorem.word }
    status                       "Funding Active"
    website                      { Faker::Internet.http_url }
    facebook_page                { Faker::Lorem.word }
    twitter_handle               { Faker::Lorem.word }
    organization                 { Faker::Company.name }
    large_image                  "https://www.filepicker.io/api/file/SduGhaCQQaaQDGehuMhs"
    story                        { Faker::Lorem.paragraph(3) }
    about                        { Faker::Lorem.paragraph(3) }
    approval_date                { Date.current.to_s(:db) }
    project_title                { Faker::Product.product_name }
    ready_for_approval           0
    organization_type            "Church"
    organization_classification  "501(c)(4)"
    publishable_key              { Faker::Lorem.word }
    seed_video                   "http://www.youtube.com/watch?v=w9Sx34swEG0"
    cultivation_video            "http://www.youtube.com/watch?v=iJBl834dq18"
    seed_mime_type               "video"
    cultivation_mime_type        "video"
    perk_permission              false
    campaign_deadline            { 1.year.from_now }
    sponsor_permission           false
    step                         "/projects/11/edit#assets"
    partial_funding              false
  end
end
