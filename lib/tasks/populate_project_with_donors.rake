require 'factory_girl'
require 'ffaker'

namespace :populate do
  desc 'Create few records om a specific project. ENV Params. N_DONORS, PROJECT_ID'
  task project_with_donors: :environment do
    Dir[Rails.root.join("spec/factories/**/*.rb")].each { |f| require f }

    if ( ENV['PROJECT_ID'].blank? )
      throw "Unexpected PROJECT_ID ENV var. Try PROJECT_ID=NUM."
    end

    project_id = ENV['PROJECT_ID'].to_i
    donors_length = ENV['N_DONORS'].blank? ? 100 : ENV['N_DONORS'].to_i

    project = Project.find(project_id)
    donors_length.times do
      FactoryGirl.create(:donation, project: project)
    end
  end
end
