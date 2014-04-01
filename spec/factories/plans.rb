FactoryGirl.define do
  factory :plan do
    name  'basic'
    membership []
    features []

    factory :plus_plan do
    	name	'plus'
    end
  end
end
