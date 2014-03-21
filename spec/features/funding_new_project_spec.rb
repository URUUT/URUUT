require 'spec_helper'

feature 'Funding a new project' do
  background do
    @user = FactoryGirl.create(:user)
    @membership = FactoryGirl.create(:membership, user:@user)
    @feature = FactoryGirl.create(:feature)
    @plan = FactoryGirl.create(:plan, membership:[@membership], features:[@feature])
    @project = FactoryGirl.create(:project, user: @user, partial_funding:true)
    login_as(@user, :scope => :user)
  end

  # this test was commented because we removed
  # Get Funding link from the menu, delete in 
  # the future after confirmation
  # scenario 'User clicks on Get Funding' do
  #   visit root_url

  #   within(".nav") do
  #     click_link 'Get Funding'
  #   end

  #   expect(page.body).to have_content('Get Started')
  # end

  scenario 'User clicks on Get Started', :js => true do
    visit new_project_path

    within('.hero') do
      click_link 'Get Started'
    end

    expect(page).to have_content('Profile')
    expect(page).to have_content('Basic Information')
  end

  scenario 'User fills Project info', :js => true do
    page.set_rack_session(:connected => true)
    visit edit_project_path(@project, anchor: 'sponsor-info')

    fill_in 'project[organization]', with: @project.organization
    select @project.organization_type, from: 'project_organization_type'
    select @project.organization_classification, from: 'project_organization_classification'
    fill_in 'project[address]', with: @project.address
    fill_in 'project[city]', with: @project.city
    select @project.state, from: 'project[state]'
    fill_in 'project_zip', with: @project.zip
    fill_in 'project_website', with: @project.website
    fill_in 'project_facebook_page', with: @project.facebook_page
    fill_in 'project_twitter_handle', with: @project.twitter_handle

    click_button 'Save & Continue'

    expect(page).to have_content('YOUR STORY')
  end

  scenario 'User fills Your Story', :js => true do
    page.set_rack_session(:connected => true)

    visit edit_project_path(@project, anchor: 'project-details')

    fill_in 'project[project_title]', with: @project.project_title
    fill_in 'project[goal]', with: @project.goal
    select @project.duration, from: 'project[duration]'
    select @project.category, from: 'project[category]'
    fill_in 'project[title]', with: @project.title
    fill_in 'project[story]', with: @project.story
    fill_in 'project[about]', with:  @project.about
    click_button 'Save & Continue'

    expect(page).to have_content('SEEDER PERKS')
  end

  scenario 'User fills SEEDER PERKS', :js => true do
    page.set_rack_session(:connected => true)

    visit edit_project_path(@project, anchor: 'perks')

    select 'No', from: 'project_perk_permission'

    click_link 'CONTINUE TO STEP 4'

    expect(page).to have_content('SPONSORSHIP DETAILS')
  end

  scenario 'User fills SPONSORSHIP DETAILS', :js => true do
    page.set_rack_session(:connected => true)

    visit edit_project_path(@project, anchor: 'sponsorship')

    select 'Yes', from: 'project_sponsorship_permission'
    check 'platinum_1'

    click_link 'next-link-to-assets'

    expect(page).to have_content('ABOUT US')
  end

  scenario 'User fills VISUALS', :js => true do
    @project.update_attributes(large_image: 'https://www.filepicker.io/api/file/dcFwLDJTrqA2encyBmAx')
    page.set_rack_session(:connected => true)

    page.execute_script("localStorage.setItem('step-assets', 'image-path')")

    visit edit_project_path(@project, anchor: 'assets')

    within(".span12") do
      click_link 'Submit Your Project for Approval'
    end

    expect(page).to have_content 'YOU DID IT!'
    expect(current_path).to eql(thank_you_pages_path)

    project = Project.last
    expect(project.organization).to eql @project.organization
    expect(project.state).to eql @project.state
    expect(project.live).to eql 0
    expect(project.ready_for_approval).to eql 1
    
  end

end
