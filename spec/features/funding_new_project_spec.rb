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

end