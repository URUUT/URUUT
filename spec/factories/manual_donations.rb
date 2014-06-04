FactoryGirl.define do
  factory :manual_donation do
    first_name  { Faker::Name.name.split(" ")[0] }
    last_name   { Faker::Name.name.split(" ")[1] }
    email       { Faker::Internet.email }
    amount      1000.00
    project
  end
end
