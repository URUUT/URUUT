namespace :users do
  desc 'Creates dummy user and subscribes him to a basic plan'
  task update_old_users: :environment do
    User.find_in_batches do |group|
      group.each do |user|
        user.build_membership.save unless user.membership
        Gateway::CustomerService.new(user).create unless user.stripe_user_token
        Gateway::PlansService.new(user).update_plan('fee') unless user.projects.any?
      end
    end
  end
end