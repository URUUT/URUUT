require 'spec_helper'

feature 'User creation' do
  before do
    @user = FactoryGirl.build(:user)
  end

  scenario "User clicks on Sign Up on root path" do
    visit root_path
    click_link('Sign Up')
    expect(current_path).to eql choose_plan_pages_path
  end

  scenario "User choise a basic plan", js: true do
    visit choose_plan_pages_path

    find('[data-plan-type="basic"]').click
    sleep(0.1)
    fill_in 'marketing_info[first_name]', with: @user.first_name
    fill_in 'marketing_info[last_name]',  with: @user.last_name
    fill_in 'marketing_info[email]',      with: @user.email
    click_button 'Next ►'

    expect(page).to have_content('Uruut Basic')

    fill_in 'user[organization]',         with: 'Custom Organization'
    fill_in 'user[telephone]',            with: '123123123123'
    fill_in 'user[password]',             with: @user.password
    fill_in 'user[password_confirmation]', with: @user.password_confirmation

    click_button('Continue')

    expect(page).to have_content('Uruut Basic')

    fill_in 'credit_card[name]',          with: @user.first_name
    fill_in 'credit_card[number]',        with: '4242424242424242'
    fill_in 'credit_card[cvc]',           with: '123'
    fill_in 'credit_card[exp_month]',     with: '12'
    fill_in 'credit_card[exp_year]',      with: 1.year.from_now
    fill_in 'credit_card[billing_address]', with: 'St fake'
    fill_in 'credit_card[city]',          with: 'Fake City'
    select 'AL',                          from: 'credit_card[state]'
    fill_in 'credit_card[zip_code]',      with: '3000'

    click_button('Submit ►')

    expect(page).to have_content 'Thank You! Your Uruut Account is Now Active.'
  end


end
