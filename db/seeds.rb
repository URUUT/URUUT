admin = User.where(email: 'admin@uruut.com').first_or_create(email: 'admin@uruut.com', first_name: 'Super', last_name: 'Admin', password: 'superAdmin', password_confirmation: 'superAdmin', role: 'admin')
pradmin = User.where(email: 'pr-admin@uruut.com').first_or_create(email: 'pr-admin@uruut.com', first_name: 'PR', last_name: 'Admin', password: 'pr@dm1n123', password_confirmation: 'pr@dm1n123', role: 'pradmin')

SponsorshipLevel.where(name: 'Platinum').first_or_create(name: 'Platinum', parent_id: 1)
SponsorshipLevel.where(name: 'Gold').first_or_create(name: 'Gold', parent_id: 2)
SponsorshipLevel.where(name: 'Silver').first_or_create(name: 'Silver', parent_id: 3)
SponsorshipLevel.where(name: 'Bronze').first_or_create(name: 'Bronze', parent_id: 4)

['fee', 'basic', 'plus'].each do |plan_name|
  Plan.create(name: plan_name, stripe_plan_id: plan_name)
end