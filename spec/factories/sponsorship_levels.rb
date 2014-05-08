FactoryGirl.define do
  factory :sponsorship_level do
    name          'Platinum'
    cost          1234.5
    description   { Faker::Lorem.paragraph(3) }
    required      false
    funding_goal  500
    project

    after(:create) do |level|
      create_list :sponsorship_benefit, 5, sponsorship_level_id: level.id,
        project_id: level.project.id
    end

    factory :custom_platinum do
      parent_id 1
    end

    factory :custom_gold do
      parent_id 2
    end

    factory :custom_silver do
      parent_id 3
    end

    factory :custom_bronze do
      parent_id 4
    end

  end
end
