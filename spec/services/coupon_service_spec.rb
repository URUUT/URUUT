require "spec_helper"

describe Gateway::CouponService do

  before(:each) do
    StripeMock.start
    @user = FactoryGirl.build(:full_user)
  end

  subject(:subject) { Gateway::CouponService.new(@user) }

  describe "#create" do
    it { expect(subject.create(nil)).to be_true }
    it { expect(subject.create('25OFF')).to be_true }
    it { expect(subject.create('asd123')).to be_false }
  end

  describe "#removeInvalid" do
    it { expect(subject.removeInvalid).to eql nil }
    it "should update coupon when it is invalid" do
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
      expect(subject.removeInvalid).to be_true
      expect(@user.coupon_stripe_token).to be_nil
      expect(Stripe::Customer.retrieve(@user.stripe_user_token).coupon).to eql ""
    end
  end

  after(:each) do
    StripeMock.stop
  end
end
