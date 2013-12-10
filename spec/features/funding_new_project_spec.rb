require 'spec_helper'

feature 'Funding a new project' do
  background do
    @user = FactoryGirl.create(:user)
    login_as(@user, :scope => :user)
  end

  scenario 'User clicks on Get Funding' do
    visit root_url

    within(".nav") do
      click_link 'Get Funding'
    end

    expect(page.body).to have_content('Get Started')
  end

  scenario 'User clicks on Get Started', :js => true do
    visit new_project_path

    within('.hero') do
      click_button 'Get Started'
    end

    expect(page).to have_content('Basic Information')
  end

  scenario 'User fills Project info', :js => true do
    project         = Project.new
    project.user    = @user
    project.project_details = false
    project.project_token = 'token'
    project.bitly = 'blablabla'
    project.save

    page.set_rack_session(:connected => true)

    visit edit_project_path(project, anchor: 'sponsor-info')

    fill_in 'project_organization', with: 'Some Project Name'
    select 'School', from: 'project_organization_type'
    select '501(c)(3)', from: 'project_organization_classification'
    fill_in 'project_address', with: '367 Beacon Street'
    fill_in 'project_city', with: 'Los Angeles'
    select 'CA', from: 'project_state'
    fill_in 'project_zip', with: '90001'
    fill_in 'project_website', with: 'www.facebook.com'
    fill_in 'project_facebook_page', with: 'facebook.com/adele'
    fill_in 'project_twitter_handle', with: 'adele'

    click_button 'Save & Continue'

    expect(page).to have_content('YOUR STORY')
  end

  scenario 'User fills Your Story', :js => true do
    project         = Project.new
    project.user    = @user
    project.project_details = false
    project.project_token = 'token'
    project.bitly = 'blablabla'
    project.save

    page.set_rack_session(:connected => true)

    visit edit_project_path(project, anchor: 'project-details')

    fill_in 'project_project_title', with: 'Project title'
    fill_in 'project_goal', with: '100'
    check 'project_partial_funding'
    select '30', from: 'project_duration'
    select 'Art / Culture', from: 'project_category'
    fill_in 'project_title', with: 'Campaign title'
    fill_in 'project_story', with: 'The story'
    fill_in 'project_about', with: 'About the project'

    click_button 'Save & Continue'

    expect(page).to have_content('SEEDER PERKS')
  end

end