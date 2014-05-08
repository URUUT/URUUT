require 'spec_helper'

describe Membership do
  before(:each) do
    @plan = FactoryGirl.create(:plan)
    @membership = FactoryGirl.create(:membership, plan: @plan)
  end

  describe "Method" do
    describe "#kind should response a plan name" do
      it { @membership.kind.should eq @plan.name }
    end

    describe "#basic_or_plus?" do
      it "should response true if a plan was assigned" do
        @membership.basic_or_plus?.should be_true
      end
      it "should response false if a plan was not assigned" do
        @membership.plan = nil
        @membership.basic_or_plus?.should be_false
      end
      it "should response false if a plan name are not correct" do
        @membership.plan.name = ''
        @membership.basic_or_plus?.should be_false
      end
    end

    describe "#clean_plan_data! should clean plan and stripe subscription" do
      before do
        @membership.clean_plan_data!
      end
      it { @membership.plan.should eq nil }
      it { @membership.stripe_subscription_id.should eq nil }
    end
  end
end
