# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :project_admin_document, :class => 'ProjectAdmin::Document' do
    document "MyString"
    project_id 1
  end
end
