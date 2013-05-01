# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
SponsorshipLevel.create({name:'Platinum', cost:'105000', description:'This is a description', required: '1'})
SponsorshipLevel.create({name:'Gold', cost:'90000', description:'This is a description', required: '1'})
SponsorshipLevel.create({name:'Silver', cost:'80000', description:'This is a description', required: '1'})
SponsorshipLevel.create({name:'Bronze', cost:'2500', description:'This is a description', required: '1'})