FactoryGirl.define do
  factory :donation do
    email           Faker::Internet.email
    customer_token  Faker::Lorem.word
    token           Faker::Lorem.word
    description     Faker::Lorem.word
    perk_name       "Custom"
    amount          100.0
    card_type       "Visa"
    card_last4      4242
    confirmed       true
    anonymous       false
    association     :project
    association     :user
  end
end
