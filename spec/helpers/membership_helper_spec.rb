require 'spec_helper'

describe MembershipsHelper do
  describe "#membership_coupon_message" do
    before(:each) do
      StripeMock.start
    end

    it "should return message with amount discount" do
      Stripe::Coupon.create(id: '25OFF', amount_off: 100)
      expect( helper.membership_coupon_message('25OFF') ).to eql \
        "You applied a $100 discount coupon to your membership"
    end

    it "should return message with percent discount" do
      Stripe::Coupon.create(id: '25OFF', percent_off: 100)
      expect( helper.membership_coupon_message('25OFF') ).to eql \
        "You applied a 100% discount coupon to your membership"
    end

    after(:each) do
      StripeMock.stop
    end
  end
end
