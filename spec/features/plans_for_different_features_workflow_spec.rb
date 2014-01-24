require 'spec_helper'

feature 'Change Plan Workflow' do
  background do
    @user = FactoryGirl.create(:user)
    @user.build_membership.save
    login_as(@user, :scope => :user)
  end

  scenario 'User visits his account information' do
    visit edit_user_registration_path

    within('.span8') do
      expect(page).to have_content("Edit account information")
    end
  end

  scenario 'User visits pricing page', js: true do
    visit edit_user_registration_path
    click_link 'Change your subscription plan.'

    within('.our-story:first-of-type') do
      expect(page).to have_content("All The Features You Need at a Sensible Price.")
    end
  end

end