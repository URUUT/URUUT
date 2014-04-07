require 'spec_helper'

feature 'Custom sponsorship creation' do
  before(:each) do
    @user = FactoryGirl.create(:user)
    @membership = FactoryGirl.create(:membership, user:@user)
    @feature = FactoryGirl.create(:feature)
    @plan = FactoryGirl.create(:plus_plan, membership:[@membership], features:[@feature])
    @project = FactoryGirl.create(:new_project, user: @user)
  end

  background do
    login_as(@user, :scope => :user)
  end

#  scenario "Should create custom level name", js: true do
#    visit edit_project_path(@project, anchor: 'sponsorship')
#
#    select 'Yes', from: 'project_sponsorship_permission'
#
#    fill_in 'level[platinum][name]', with: 'Ninja'
#    fill_in 'level[bronze][name]', with: 'Ronnin'
#
#    click_link 'next-link-to-assets'
#    within('#confirm-changes') { click_button 'Save changes' }
#    
#    expect(page).to have_content('ABOUT US')
#  end


  scenario "Should display level name fields", js: true do
    page.set_rack_session(connected: true)

    visit edit_project_path(@project, anchor: 'sponsorship')

    select 'Yes', from: 'project_sponsorship_permission'

    expect( page.has_field?('level[platinum][name]') ).to be_true
    expect( page.has_field?('level[gold][name]') ).to be_true
    expect( page.has_field?('level[silver][name]') ).to be_true
    expect( page.has_field?('level[bronze][name]') ).to be_true
  end

  scenario "A live project can't edit custom level names", js: true do
    @project = FactoryGirl.create(:project, user: @user, partial_funding:true)
    page.set_rack_session(connected: true)

    visit edit_project_path(@project, anchor: 'sponsorship')

    select 'Yes', from: 'project_sponsorship_permission'

    expect( page.has_field?('level[platinum][name]') ).to be_false
    expect( page.has_field?('level[gold][name]') ).to be_false
    expect( page.has_field?('level[silver][name]') ).to be_false
    expect( page.has_field?('level[bronze][name]') ).to be_false
  end

  scenario "Should not display level name fields if there is not a Plus User", js: true do
    @plan.name = 'basic'
    @plan.save!
    
    page.set_rack_session(connected: true)

    visit edit_project_path(@project, anchor: 'sponsorship')

    select 'Yes', from: 'project_sponsorship_permission'

    expect( page.has_field?('level[platinum][name]') ).to be_false
    expect( page.has_field?('level[gold][name]') ).to be_false
    expect( page.has_field?('level[silver][name]') ).to be_false
    expect( page.has_field?('level[bronze][name]') ).to be_false
  end
end