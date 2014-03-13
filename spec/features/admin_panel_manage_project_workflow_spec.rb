require 'spec_helper'

feature 'Transparency Woorkroom Workflow' do
  background do
    @user = FactoryGirl.create(:user)
    login_as(@user, :scope => :user)

    @project = FactoryGirl.create(:project, user: @user)
  end

  scenario 'User visits his profile' do
    visit user_path(@user)

    within('.span8') do
      expect(page).to have_content("Projects I've Created")
    end
  end

  scenario "User goes to Project's Panel of an Active Funding Project", js: true do
    @project.update_attributes(campaign_deadline: 3.days.from_now)
    visit user_path(@user)

    select 'Funding Active', from: 'projects-created'

    expect(page).to have_content('PROJECT ADMIN PANEL')
  end

  scenario "User visits Project Admin Panel of the Project", js: true do
    @project.update_attributes(campaign_deadline: 3.days.from_now)
    visit project_admin_project_path(@project)

    within('.span8') do
      expect(page).to have_content('FUNDING TRACKER')
    end
  end

  # scenario "User visits Manage of the Project", js: true do
  #   @project.update_attributes(campaign_deadline: 3.days.from_now)
  #   visit project_admin_project_path(@project)

  #   click_link 'Manage Project'

  #   within('.span9') do
  #     expect(page).to have_content('MY PROJECT COVER PHOTO')
  #   end
  # end

  scenario "User updates Project Details", js: true do
    @project.update_attributes(campaign_deadline: 3.days.from_now)
    visit project_admin_project_path(@project)

    click_link 'Manage Project'
    click_link 'PROJECT DETAILS'

    fill_in 'project_title', with: ''
    fill_in 'project_story', with: 'My Story Update'
    fill_in 'project_about', with: 'About Updated'

    click_button 'Save Updates'

    expect(page).to have_content('Field Required')
  end

  scenario "User visits Project Visual", js: true do
    @project.update_attributes(campaign_deadline: 3.days.from_now)
    visit project_admin_project_path(@project)

    click_link 'Manage Project'
    click_link 'STORY VISUAL'

    expect(page).to have_content('ABOUT US')
  end

  scenario "User updates Project Updates", js: true do
    @project.update_attributes(campaign_deadline: 3.days.from_now)
    visit project_admin_project_path(@project)

    click_link 'Manage Project'
    click_link 'PROJECT UPDATES'

    fill_in 'project_update_title', with: ''
    fill_in 'project_update_content', with: 'Content updated'

    click_button 'POST PROJECT UPDATE'

    expect(page).to have_content('Field Required')
  end

end