require 'spec_helper'

describe SponsorshipBenefit do

	it { should respond_to(:name) }
	it { should respond_to(:sponsorship_level_id) }
	it { should respond_to(:project_id, :status) }
	it { should respond_to(:cost) }

  describe "#default_plus_level" do
    before(:each) do
      @project = FactoryGirl.create(:project)
      @benefits = FactoryGirl.create_list(:sponsorship_benefit, 5, \
        project: @project, sponsorship_level_id: 1)
      @default_benefit = SponsorshipBenefit::SPONSORSHIP_BENEFITS[1]
    end

    it { expect(SponsorshipBenefit.default_plus_level(@project, 1, 1)).to \
      include @benefits.first }
    it { expect(SponsorshipBenefit.default_plus_level(@project, 1, 1)).to \
      include @default_benefit.first }
    it { expect(SponsorshipBenefit.default_plus_level(@project, 1, 1)).to \
      include @default_benefit.second }
  end
end
