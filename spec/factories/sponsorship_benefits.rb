FactoryGirl.define do
  factory :sponsorship_benefit do
    name      'Benefit'
    status    true
    project

    factory :sponsorship_benefit_platinum do
      sponsorship_level_id 1
    end
  end
end
