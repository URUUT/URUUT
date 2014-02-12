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

  # scenario 'User funds $10 to a Project', js: true do
  #   visit project_path(@project)

  #   page.first('.seed-level').click_link('Fund Now')

  #   expect(page).to have_content('PAYMENT INFORMATION')
  # end

  # scenario 'User fills payment information', js: true do
  #   WebMock.allow_net_connect!

  #   visit default_perk_donations_path(
  #     amount:      '10',
  #     name:        'LEVEL 1',
  #     description: '10 Uruut Reward Points',
  #     project_id:  @project.id)

  #   page.execute_script('stripe_pub_key = "pk_test_WRrfoQLUDkpGHAxCmOY0Y6ud"')
  #   page.execute_script("$('#donation_project_id').val(#{@project.id})")

  #   fill_in 'name', with: @user.first_name
  #   fill_in 'card_number', with: '4242424242424242'
  #   fill_in 'card_code', with: '123'
  #   fill_in 'card_month', with: '12'
  #   fill_in 'card_year', with: 1.year.from_now.year
  #   check 'donation_anonymous'

  #   click_button 'Contribute'

  #   sleep(5)

  #   expect(page).to have_content('CONFIRM')

  #   WebMock.disable_net_connect!(allow_localhost: true)
  # end

  # scenario 'User confirms $10 donation', js: true do
  #   WebMock.allow_net_connect!

  #   visit default_perk_donations_path(
  #     amount:      '10',
  #     name:        'LEVEL 1',
  #     description: '10 Uruut Reward Points',
  #     project_id:  @project.id)

  #   page.execute_script('stripe_pub_key = "pk_test_WRrfoQLUDkpGHAxCmOY0Y6ud"')
  #   page.execute_script("$('#donation_project_id').val(#{@project.id})")

  #   fill_in 'name', with: @user.first_name
  #   fill_in 'card_number', with: '4242424242424242'
  #   fill_in 'card_code', with: '123'
  #   fill_in 'card_month', with: '12'
  #   fill_in 'card_year', with: 1.year.from_now.year
  #   check 'donation_anonymous'
  #   click_button 'Contribute'
  #   sleep(5)

  #   click_button 'Confirm'
  #   sleep(5)

  #   expect(page).to have_content('THANK YOU!')

  #   WebMock.disable_net_connect!(allow_localhost: true)
  # end

end