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
  end
end
