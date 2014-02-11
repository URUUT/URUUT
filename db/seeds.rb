# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

admin = User.where(email: 'admin@uruut.com').first_or_create(email: 'admin@uruut.com', first_name: 'Super', last_name: 'Admin', password: 'superAdmin', password_confirmation: 'superAdmin', role: 'admin')
pradmin = User.where(email: 'pr-admin@uruut.com').first_or_create(email: 'pr-admin@uruut.com', first_name: 'PR', last_name: 'Admin', password: 'pr@dm1n123', password_confirmation: 'pr@dm1n123', role: 'pradmin')

SponsorshipLevel.where(name: 'Platinum').first_or_create(name: 'Platinum')
SponsorshipLevel.where(name: 'Gold').first_or_create(name: 'Gold')
SponsorshipLevel.where(name: 'Silver').first_or_create(name: 'Silver')
SponsorshipLevel.where(name: 'Bronze').first_or_create(name: 'Bronze')

['fee', 'basic', 'plus'].each do |plan_name|
  Plan.create(name: plan_name, stripe_plan_id: plan_name)
end