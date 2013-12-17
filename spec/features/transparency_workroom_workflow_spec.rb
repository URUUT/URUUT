require 'spec_helper'

feature 'Transparency Woorkroom Workflow' do
  background do
    @user = FactoryGirl.create(:user)
    login_as(@user, :scope => :user)

    @project = FactoryGirl.create(:project, user: @user)
  end

  scenario 'User visits his profile' do
    visit user_path(@user)

    expect(page).to have_content("PROJECTS I'VE CREATED")
  end

  scenario "User goes to Project's Panel of an Active Funding Project", js: true do
    @project.update_attributes(campaign_deadline: 3.days.from_now)
    visit user_path(@user)

    select 'Funding Active', from: 'projects-created'

    expect(page).to have_content('PROJECT ADMIN PANEL')
  end

end