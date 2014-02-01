require 'spec_helper'

feature 'Change Plan Workflow' do
  background do
    @user = FactoryGirl.create(:user)
    @user.build_membership.save
    login_as(@user, :scope => :user)

    ['fee', 'basic', 'plus'].each do |plan_name|
      Plan.new(name: plan_name).save
    end
  end

  scenario 'User visits his account information' do
    visit edit_user_registration_path

    within('.span8') do
      expect(page).to have_content("Edit account information")
    end
  end

  # scenario 'User visits pricing page', js: true do
  #   visit edit_user_registration_path
  #   click_link 'Change your subscription plan.'

  #   within('.our-story:first-of-type') do
  #     expect(page).to have_content("All The Features You Need at a Sensible Price.")
  #   end
  # end

  # scenario 'User choose a fee-based plan', js: true do
  #   visit edit_user_registration_path
  #   click_link 'Change your subscription plan.'

  #   within('.plan:first-of-type') do
  #     click_button 'Select ►'
  #   end

  #   expect(page).to have_content('Your membership is FEE')
  # end

  # scenario 'User choose a basic plan', js: true do
  #   visit edit_user_registration_path
  #   click_link 'Change your subscription plan.'

  #   within('.plan:nth-child(2)') do
  #     click_button 'Select ►'
  #   end

  #   expect(page).to have_content('Your membership is BASIC')
  # end

  # scenario 'User choose a plus plan', js: true do
  #   visit edit_user_registration_path
  #   click_link 'Change your subscription plan.'

  #   within('.plan:nth-child(3)') do
  #     click_button 'Select ►'
  #   end

  #   expect(page).to have_content('Your membership is PLUS')
  # end

end