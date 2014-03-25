FactoryGirl.define do
  factory :sponsorship_level do
    name          'Platinum'
    cost          1234.5
    description   { Faker::Lorem.paragraph(3) }
    required      false
    funding_goal  500
    project

    after(:create) do |level|
      create :sponsorship_benefit, sponsorship_level_id: level.id,
        project_id: level.project.id
    end
  end
end
