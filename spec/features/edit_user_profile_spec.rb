require "spec_helper"

feature "Edit User" do
  before(:each) do
    StripeMock.start
    @user = FactoryGirl.create(:full_user)
    @user.membership.plan = FactoryGirl.create(:plan)
    login_as(@user, scope: :user)
  end

  context "coupon" do
    scenario "when a user try change it" do
      visit edit_user_payment_method_path(@user)
      expect( page.has_field?('coupon') ).to be_false
    end

    scenario "remove coupon when downgrade an user plan" do
      Stripe::Plan.create(
        :amount => 2000, :interval => 'month', :name => 'Amazing Gold Plan',
        :currency => 'usd', :id => 'basic'
      )
      @user.membership.plan = FactoryGirl.create(:plus_plan)
      @user.membership.save
      visit new_user_payment_method_path(@user, { "plan_id" => "basic" })

      fill_in 'credit_card[name]',          with: @user.first_name
      fill_in 'credit_card[number]',        with: '4242424242424242'
      fill_in 'credit_card[cvc]',           with: '123'
      fill_in 'credit_card[exp_month]',     with: '12'
      fill_in 'credit_card[exp_year]',      with: 1.year.from_now.year
      fill_in 'credit_card[billing_address]', with: 'St fake'
      fill_in 'credit_card[city]',          with: 'Fake City'
      select 'AL',                          from: 'credit_card[state]'
      fill_in 'credit_card[zip_code]',      with: '3000'

      click_button('Submit ►')
      @user.reload
      expect(@user.coupon_stripe_token).to be_nil
      expect(Stripe::Customer.retrieve(@user.stripe_user_token).discount).to be_nil
      expect(@user.membership.kind).to eql 'basic'
    end

    scenario "change coupon when upgrade an user plan" do
      Stripe::Plan.create(
        :amount => 2000, :interval => 'month', :name => 'Amazing Gold Plan',
        :currency => 'usd', :id => 'plus'
      )
      Stripe::Coupon.create(percent_off: 25, duration: 'repeating',
          duration_in_months: 3, id: '30OFF')
      @user.membership.plan = FactoryGirl.create(:plan)
      visit new_user_payment_method_path(@user, { "plan_id" => "plus" })

      fill_in 'credit_card[name]',          with: @user.first_name
      fill_in 'credit_card[number]',        with: '4242424242424242'
      fill_in 'credit_card[cvc]',           with: '123'
      fill_in 'credit_card[exp_month]',     with: '12'
      fill_in 'credit_card[exp_year]',      with: 1.year.from_now.year
      fill_in 'credit_card[billing_address]', with: 'St fake'
      fill_in 'credit_card[city]',          with: 'Fake City'
      select 'AL',                          from: 'credit_card[state]'
      fill_in 'credit_card[zip_code]',      with: '3000'
      fill_in 'coupon',                     with: '30OFF'

      click_button('Submit ►')

      @user.reload
      expect(@user.coupon_stripe_token).to eql '30OFF'
      expect(@user.membership.kind).to eql 'plus'
    end

    scenario "does not use coupon when upgrade an user plan" do
      Stripe::Plan.create(
        :amount => 2000, :interval => 'month', :name => 'Amazing Gold Plan',
        :currency => 'usd', :id => 'plus'
      )
      @user.membership.plan = FactoryGirl.create(:plan)
      @user.membership.save!
      visit new_user_payment_method_path(@user, { "plan_id" => "plus" })

      fill_in 'credit_card[name]',          with: @user.first_name
      fill_in 'credit_card[number]',        with: '4242424242424242'
      fill_in 'credit_card[cvc]',           with: '123'
      fill_in 'credit_card[exp_month]',     with: '12'
      fill_in 'credit_card[exp_year]',      with: 1.year.from_now.year
      fill_in 'credit_card[billing_address]', with: 'St fake'
      fill_in 'credit_card[city]',          with: 'Fake City'
      select 'AL',                          from: 'credit_card[state]'
      fill_in 'credit_card[zip_code]',      with: '3000'

      click_button('Submit ►')

      @user.reload
      expect(@user.coupon_stripe_token).to eql nil
      expect(@user.membership.kind).to eql 'plus'
    end
  end

  after(:each) do
    StripeMock.stop
  end
end
