require "spec_helper"

describe Gateway::PlansService do
  describe "#update_plan" do
    before(:each) do
      StripeMock.start
      Stripe::Plan.create(
        :amount => 2000,
        :interval => 'month',
        :name => 'Amazing Gold Plan',
        :currency => 'usd',
        :id => 'plus'
      )

      @user = FactoryGirl.create(:user)
      @membership = FactoryGirl.create(:membership, user: @user)
      customer = Gateway::CustomerService.new(@user)
      customer.create
      @card = CreditCard.new({
        number: '4242424242424242',
        exp_month: 12,
        exp_year: 1.year.from_now,
        cvc: '123',
        name: 'name',
        address_line1: 'address',
        address_city: 'NYC',
        address_zip: '0000',
        address_state: 'NY'
        })
      Gateway::CardsService.new(@user).create(@card)
      Stripe::Coupon.create(
        :percent_off => 25,
        :duration => 'repeating',
        :duration_in_months => 3,
        :id => '25OFF'
      )
      @plan_service = Gateway::PlansService.new(@user)
    end

    it "should create a new plan when it is not assigned to user" do
      @plan_service.update_plan('plus')

      customer = Stripe::Customer.retrieve(@user.stripe_user_token)
      expect(customer.subscriptions.count).to eql 1
      expect(customer.subscriptions.data[0].plan.id).to eql 'plus'
    end

    it "should update a plan when a user has a plan" do
      Stripe::Plan.create(
        :amount => 2000,
        :interval => 'month',
        :name => 'Amazing Gold Plan',
        :currency => 'usd',
        :id => 'basic'
      )

      @plan_service.update_plan('plus')
      @plan_service.update_plan('basic')

      customer = Stripe::Customer.retrieve(@user.stripe_user_token)
      expect(customer.subscriptions.count).to eql 1
      expect(customer.subscriptions.data[0].plan.id).to eql 'basic'
    end

    context 'coupons' do
      it "undefined" do
        @plan_service.addCoupon(nil)
        @plan_service.update_plan('plus')

        customer = Stripe::Customer.retrieve(@user.stripe_user_token)
        expect(customer.discount).to eql nil
      end

      it "inexistent" do
        @plan_service.addCoupon('asd')
        @plan_service.update_plan('plus')

        customer = Stripe::Customer.retrieve(@user.stripe_user_token)
        expect(customer.discount).to eql nil
      end

      #it "exists" do
      #  @plan_service.addCoupon('25OFF')
      #  @plan_service.update_plan('plus')

      #  customer = Stripe::Customer.retrieve(@user.stripe_user_token)
      #  expect(customer.subscriptions.count).to eql 1
      #  expect(customer.subscriptions.data[0].plan.id).to eql 'plus'
      #  expect(customer.discount.coupon.id).to eql '25OFF'
      #end
    end

    after { StripeMock.stop }
  end

end
