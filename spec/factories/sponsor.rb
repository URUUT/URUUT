FactoryGirl.define do
  factory :sponsor do
    payment_type "Credit Card"
    name "John Smith"
    card_name "John Smith"
    email Faker::Internet.email
  end
end