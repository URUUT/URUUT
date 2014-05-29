FactoryGirl.define do
  factory :plan do
    name  'basic'
    membership []
    features []

    factory :plus_plan do
    	name	'plus'
    end

    factory :fee_plan do
      name 'fee'
    end
  end
end
