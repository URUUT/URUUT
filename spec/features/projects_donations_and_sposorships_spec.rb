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

end