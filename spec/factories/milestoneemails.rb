# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :milestoneemail do
    fifteen_percent false
    fifty_percent false
    seventy_five_percent false
    ninety_percent false
    project_id 1
  end
end
