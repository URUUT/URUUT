require 'spec_helper'

feature 'Donating and sponsoring to a Project' do
  background do
    @user = FactoryGirl.build(:user)
    User.any_instance.stub(:membership_plan).and_return(FactoryGirl.build(:plan))
    Plan.any_instance.stub(:has_feature?).with('partial_funding').and_return(false)
    @project = FactoryGirl.create(:project)
  end

  context 'when a unsigned user makes a donation' do
    scenario 'User funds $10 to a Project', js: true do
      visit project_path(@project)

      page.first('.seed-level').click_link('Fund Now ►')

      expect(page).to have_content('PAYMENT INFORMATION')
      expect(page).to have_content(@project.project_title.upcase)

      within('.perk-name') do
        expect(page).to have_content 'LEVEL 1'
      end
    end

    scenario 'User fills payment information', js: true do
      WebMock.allow_net_connect!

      visit default_perk_donations_path(
        amount:      '10',
        name:        'LEVEL 1',
        description: '10 Uruut Reward Points',
        project_id:  @project.id)

      page.execute_script('stripe_pub_key = "pk_test_WRrfoQLUDkpGHAxCmOY0Y6ud"')
      page.execute_script("$('#donation_project_id').val(#{@project.id})")

      fill_in 'user[first_name]', with: @user.first_name
      fill_in 'user[last_name]', with: @user.last_name
      fill_in 'user[email]', with: @user.email
      fill_in 'user[password]', with: @user.password
      fill_in 'user[password_confirmation]', with: @user.password_confirmation

      fill_in 'name', with: @user.first_name
      fill_in 'card_number', with: '4242424242424242'
      fill_in 'card_code', with: '123'
      fill_in 'card_month', with: '12'
      fill_in 'card_year', with: 1.year.from_now.year
      check 'donation_anonymous'

      click_button 'Contribute'

      sleep(5)

      expect(page).to have_content('CONFIRM')

      WebMock.disable_net_connect!(allow_localhost: true)

      expect(User.where(email: @user.email)).to exist
      expect(User.last.donations.unscoped.last.email).to eql @user.email
    end
  end

  context 'when a signin user makes a donation' do
    before(:each) do
      @user = FactoryGirl.create(:user)
      login_as(@user, :scope => :user)
    end

    scenario 'User funds $10 to a Project', js: true do
      visit project_path(@project)

      page.first('.seed-level').click_link('Fund Now')

      expect(page).to have_content('PAYMENT INFORMATION')
      expect(page).to have_content(@project.project_title.upcase)

      within('.perk-name') do
        expect(page).to have_content 'LEVEL 1'
      end
    end

    scenario 'User fills payment information', js: true do
      WebMock.allow_net_connect!

      visit default_perk_donations_path(
        amount:      '10',
        name:        'LEVEL 1',
        description: '10 Uruut Reward Points',
        project_id:  @project.id)

      page.execute_script('stripe_pub_key = "pk_test_WRrfoQLUDkpGHAxCmOY0Y6ud"')
      page.execute_script("$('#donation_project_id').val(#{@project.id})")

      fill_in 'name', with: @user.first_name
      fill_in 'card_number', with: '4242424242424242'
      fill_in 'card_code', with: '123'
      fill_in 'card_month', with: '12'
      fill_in 'card_year', with: 1.year.from_now.year
      check 'donation_anonymous'

      click_button 'Contribute'

      sleep(5)

      expect(page).to have_content('CONFIRM')

      WebMock.disable_net_connect!(allow_localhost: true)
    end

    scenario 'User confirms $10 donation', js: true do
      WebMock.allow_net_connect!

      visit default_perk_donations_path(
        amount:      '10',
        name:        'LEVEL 1',
        description: '10 Uruut Reward Points',
        project_id:  @project.id)

      page.execute_script('stripe_pub_key = "pk_test_WRrfoQLUDkpGHAxCmOY0Y6ud"')
      page.execute_script("$('#donation_project_id').val(#{@project.id})")

      fill_in 'name', with: @user.first_name
      fill_in 'card_number', with: '4242424242424242'
      fill_in 'card_code', with: '123'
      fill_in 'card_month', with: '12'
      fill_in 'card_year', with: 1.year.from_now.year
      check 'donation_anonymous'
      click_button 'Contribute'
      sleep(5)

      click_button 'Confirm'
      sleep(5)

      expect(page).to have_content('THANK YOU!')

      donations = @user.donations.where(project_id: @project)
      expect(donations).to exist
      expect(donations.last.amount).to eql 10.0
      expect(donations.last.perk_name.downcase).to eql 'level 1'

      WebMock.disable_net_connect!(allow_localhost: true)
    end
  end


end
