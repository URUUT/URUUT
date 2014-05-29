# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user do
    first_name  { Faker::Name.first_name }
    last_name   { Faker::Name.last_name }
    email       { Faker::Internet.email }
    password              'asdasdasd'
    password_confirmation 'asdasdasd'

    factory :admin do
      role      'admin'
    end

    factory :full_user do
      membership

      after(:build) do |user, evaluator|
        card_token = StripeMock.generate_card_token(last4: "9191", exp_year: 2.years.from_now)
        Stripe::Coupon.create(percent_off: 25, duration: 'repeating',
          duration_in_months: 3, id: '25OFF')
        customer = Stripe::Customer.create(description: "Customer")
        customer.cards.create(:card => card_token)
        user.stripe_user_token = customer.id
        #user.stripe_card_token = "tok_2jIDoCDYm7WkO0"
        user.coupon_stripe_token = '25OFF'
      end
    end
  end
end
