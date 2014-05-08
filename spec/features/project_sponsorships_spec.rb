require 'spec_helper'

feature 'Sponsoring to a Project' do
  background do
    @user = FactoryGirl.create(:user)
    @project = FactoryGirl.create(:project_with_sponsor)
    login_as(@user, :scope => :user)
  end

  scenario 'User sponsoring a project', js: true do
    visit project_path(@project)

    within('#myTab2') do
      click_link('Sponsor')
    end
    page.first('.seed-level').click_link('Sponsor')

    expect(page).to have_content('SPONSORSHIP COST')
  end

  scenario 'User fills sponsoring data', js: true do
    WebMock.allow_net_connect!
    
    visit new_project_sponsor_path(@project, level: 'platinum')
    
    check 'sponsor[anonymous]'
    fill_in 'project_sponsor[name]', with: 'Bussines Name'
    select 'Foundation', from: 'type'
    fill_in 'project_sponsor[site]', with: 'www.google.com.ar'
    fill_in 'project_sponsor[mission]', with: 'My new mission is grab the world'

    fill_in 'card-number', with: '4242424242424242'
    fill_in 'cvv',         with: '123'
    fill_in 'month',       with: '12'
    fill_in 'year',        with: 1.year.from_now

    page.execute_script("$('#new_sponsor').first().submit();")
    sleep(5)
    click_link('project-submit')
    sleep(5)
    
    expect(page).to have_content('THANK YOU!') 

    sponsor = ProjectSponsor.last
    expect(sponsor.name).to eql 'Bussines Name' 
    expect(sponsor.level_id).to eql 1
    expect(sponsor.project_id).to eql @project.id

    WebMock.disable_net_connect!(allow_localhost: true)
  end

end
