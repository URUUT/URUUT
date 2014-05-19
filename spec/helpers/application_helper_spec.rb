require 'spec_helper'

describe ApplicationHelper do
  describe "#can_use_coupon?" do
    before(:each) do
      StripeMock.start
      @user = FactoryGirl.create(:full_user)
      @user.membership.plan = FactoryGirl.create(:plan)
    end

    it "return true if there is a new user" do
      @user.coupon_stripe_token = nil
      expect( helper.can_use_coupon?(@user) ).to be_true
    end

    it { expect( helper.can_use_coupon?(@user) ).to be_false }

    it "return true if there is an inactive coupon" do
      Stripe::Coupon.stub(:retrieve).with(@user.coupon_stripe_token).and_return(
        Stripe::Util.convert_to_stripe_object( {
          "id" => @user.coupon_stripe_token,
          "created" => 1399939596,
          "percent_off" => 50,
          "amount_off" => nil,
          "currency" => "usd",
          "object" => "coupon",
          "livemode" => false,
          "duration" => "once",
          "redeem_by" => 1400025599,
          "max_redemptions" => 1,
          "times_redeemed" => 1,
          "duration_in_months" => nil,
          "valid" => false
        } ,nil));
      expect( helper.can_use_coupon?(@user) ).to be_true
    end

    after(:each) do
      StripeMock.stop
    end
  end

  describe "#upgrade_plan?" do
    before(:each) do
      StripeMock.start
      @user = FactoryGirl.create(:full_user)
      @user.membership.plan = FactoryGirl.create(:plan)
    end

    it { expect( helper.upgrade_plan?(@user, @user.membership_kind) ).to be_false }
    it { expect( helper.upgrade_plan?(@user, 'plus') ).to be_true }

    after(:each) do
      StripeMock.stop
    end
  end
end
