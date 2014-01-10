# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :subscription do
    membership nil
    stripe_plan_id "MyString"
  end
end
