namespace :stripe do
  namespace :dummy do
    desc 'Creates dummy user and subscribes him to a basic plan'
    task subscribe_to_plan: :environment do
      user = User.create(first_name: 'stripe', last_name: 'dummy',
        email: 'stripe@uruut.com', password: 'bandofcoders',
        password_confirmation: 'bandofcoders')

      Gateway::CustomerService.new(user).create
      Gateway::CardsService.new(user).create('4242424242424242', 11, 2015, '123')
      Gateway::PlansService.new(user).update_plan('basic')
    end

    desc 'Unsubscribe user from basic plan'
    task unsubscribe_to_plan: :environment do
      user = User.where(email: 'stripe@uruut.com').first

      Gateway::PlansService.new(user).cancel_plan
    end
  end
end