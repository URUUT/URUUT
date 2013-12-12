require 'spec_helper'

feature 'Donating and sponsoring to a Project' do
  background do
    @user = FactoryGirl.create(:user)
    @project = FactoryGirl.create(:project)
    login_as(@user, :scope => :user)
  end

  scenario 'User visits Project#show' do
    visit project_path(@project)

    within('li.active') do
      expect(page).to have_content('About Us')
    end
  end

  scenario 'User funds $10 to a Project', js: true do
    visit project_path(@project)

    page.first('.seed-level').click_link('Fund Now')

    expect(page).to have_content('PAYMENT INFORMATION')
  end

end