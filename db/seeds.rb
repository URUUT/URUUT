# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

User.where(email: 'admin@uruut.com').first_or_create(email: 'admin@uruut.com', first_name: 'Super', last_name: 'Admin', password: 'superAdmin', password_confirmation: 'superAdmin', roles: ['admin'])