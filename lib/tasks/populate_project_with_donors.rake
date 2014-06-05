namespace :populate do
  desc 'Create few records om a specific project. ENV Params. N_DONORS, PROJECT_ID'
  task project_with_donors: :environment do

    if ( ENV['PROJECT_ID'].blank? )
      throw "Unexpected PROJECT_ID ENV var. Try PROJECT_ID=NUM."
    end

    project_id = ENV['PROJECT_ID'].to_i
    donors_length = ENV['N_DONORS'].blank? ? 100 : ENV['N_DONORS'].to_i

    project = Project.find(project_id)
    user = User.find(1)
    donors_length.times do |i|
      Donation.create({
        email:              "email-#{i}",
        customer_token:     "customer-#{i}",
        token:              "token-#{i}",
        description:        "description-#{i}",
        perk_name:          "Custom",
        amount:             100.0,
        card_type:          "Visa",
        card_last4:         4242,
        confirmed:          true,
        anonymous:          false,
        project_id:         project.id,
        user_id:            user.id
      })
    end
  end
end
