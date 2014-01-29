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

  scenario "User visits Transparency Workroom of the Project", js: true do
    @project.update_attributes(campaign_deadline: 3.days.from_now)
    visit project_admin_project_path(@project)

    click_link 'Transparency Workroom'

    within('.span9') do
      expect(page).to have_content('DOCUMENT ROOM')
    end
  end

  scenario "User adds a video", js: true do
    WebMock.allow_net_connect!
    @project.update_attributes(campaign_deadline: 3.days.from_now)
    visit project_admin_project_path(@project)

    click_link 'Transparency Workroom'
    click_link 'PHOTOS & VIDEOS'
    click_link 'UPLOAD A VIDEO'

    within('#save-video') do
      fill_in 'video_link', with: 'http://www.youtube.com/watch?v=EHkozMIXZ8w'
      click_button 'Submit video'
    end

    sleep(15)

    expect(page).to have_content(/Delete/)
    WebMock.disable_net_connect!(allow_localhost: true)
  end

  scenario "User adds a comment", js: true do
    @project.update_attributes(campaign_deadline: 3.days.from_now)
    visit project_admin_project_path(@project)

    click_link 'Transparency Workroom'
    click_link 'COMMUNICATION'

    within('.new_post') do
      fill_in 'post_title', with: 'Post Title'
      fill_in 'post_body', with: 'Post Body'
      click_button 'Create Post'
    end

    expect(page).to have_content('SUCCESSFULLY CREATED POST')
  end

  scenario "User visits transparency workroom of a Funding Completed Project", js: true do
    @project.update_attributes(campaign_deadline: 1.days.ago)
    @project.posts.create(title: 'Post Title', body: 'Post Body', user_id: @user.id)
    visit project_transparency_workroom_index_path(@project)

    expect(page).to have_content('POST TITLE')
    expect(page).to have_content('Post Body')
  end

end
