require 'spec_helper'

feature 'Funding a new project' do

  scenario 'User clicks on Get Funding' do
    user = FactoryGirl.create(:user)
    login_as(user, :scope => :user)

    visit root_url

    within(".nav") do
      click_link 'Get Funding'
    end

    expect(page.body).to have_content('Get Started')
  end

  scenario 'User clicks on Get Started', :js => true do
    user = FactoryGirl.create(:user)
    login_as(user, :scope => :user)

    visit new_project_path

    within('.hero') do
      click_button 'Get Started'
    end

    expect(page).to have_content('Basic Information')
  end

end