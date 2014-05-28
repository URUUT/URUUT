require "spec_helper"

feature "Cupons on checkouts" do
  background do
    @user = FactoryGirl.build(:user)
    StripeMock.start
    Stripe::Coupon.create(id: '25OFF')
    Stripe::Plan.create(
      :amount => 2000,
      :interval => 'month',
      :name => 'Amazing Gold Plan',
      :currency => 'usd',
      :id => 'plus'
    )
  end

  scenario "User choise a plus plan", js: true do
    WebMock.allow_net_connect!
    visit new_user_registration_path(
      full_registration: 1,
      sign_up_plan: :plus,
      marketing_info_id: 20
    )

    fill_basic_sign_up_fields

    click_button('Continue')

    expect(page).to have_content('Uruut Plus')

    fill_credit_card_fields
    fill_in 'coupon', with: "25OFF"

    click_button('Submit ►')

    expect(page).to have_content 'Thank You! Your Uruut Account is Now Active.'
    expect(page).to have_content 'YOU USED A COUPON: 25OFF'
    WebMock.disable_net_connect!(allow_localhost: true)

    expect(User.last.coupon_stripe_token).to eql '25OFF'
  end

  scenario "an user adds an inexistent coupon" do
    WebMock.allow_net_connect!
    visit new_user_registration_path(
      full_registration: 1,
      sign_up_plan: :plus,
      marketing_info_id: 20
    )

    within(:css, '#new_user') do
      fill_basic_sign_up_fields
    end
    click_button('Continue')

    fill_credit_card_fields
    fill_in 'coupon', with: "asd123"

	  click_button('Submit ►')

    expect(page.body).to have_content "No such coupon asd123"
    WebMock.disable_net_connect!(allow_localhost: true)
  end

  after { StripeMock.stop }
end

def fill_basic_sign_up_fields
  fill_in 'user[first_name]',           with: @user.first_name
  fill_in 'user[last_name]',            with: @user.last_name
  fill_in 'user[email]',                with: @user.email
  fill_in 'user[organization]',         with: 'Custom Organization'
  fill_in 'user[telephone]',            with: '123123123123'
  fill_in 'user[password]',             with: @user.password
  fill_in 'user[password_confirmation]', with: @user.password_confirmation
end

def fill_credit_card_fields
  fill_in 'credit_card[name]',          with: @user.first_name
  fill_in 'credit_card[number]',        with: '4242424242424242'
  fill_in 'credit_card[cvc]',           with: '123'
  fill_in 'credit_card[exp_month]',     with: '12'
  fill_in 'credit_card[exp_year]',      with: 1.year.from_now.year
  fill_in 'credit_card[billing_address]', with: 'St fake'
  fill_in 'credit_card[city]',          with: 'Fake City'
  select 'AL',                          from: 'credit_card[state]'
  fill_in 'credit_card[zip_code]',      with: '3000'
end
