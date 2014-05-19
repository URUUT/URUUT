require "spec_helper"

describe Gateway::CouponService do

  describe "#create" do
    before(:each) do
      StripeMock.start
      @user = FactoryGirl.build(:full_user)
    end

    subject(:subject) { Gateway::CouponService.new(@user) }

    it { expect(subject.create(nil)).to be_true }
    it { expect(subject.create('25OFF')).to be_true }
    it { expect(subject.create('asd123')).to be_false }

    after(:each) do
      StripeMock.stop
    end
  end
end
