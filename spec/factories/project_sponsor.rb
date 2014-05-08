FactoryGirl.define do
  factory :project_sponsor do
    card_token    Faker::Lorem.word
    cost          750.0
    logo          "https://www.filepicker.io/api/file/SduGhaCQQaaQDGehuMhs"
    mission       "Tell "
    name          "TESTING MAIL"
    payment       "Unpaid"
    status        "Unconfirmed"
    level_id      4
    card_type     "Visa"
    card_last4    4242
    site          "www.testmail.com"
    confirmed     true
    sponsor_type  "Business"
    customer_id   Faker::Lorem.word
    anonymous     false
    approved      false
    association   :project
    association   :sponsor
  end
end