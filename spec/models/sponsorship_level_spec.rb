require 'spec_helper'

describe SponsorshipLevel do

	it { should respond_to(:name) }
	it { should respond_to(:cost) }
	it { should respond_to(:description) }
	it { should respond_to(:required) }
	it { should respond_to(:funding_goal) }

  describe "#by_project" do
    before do
      @project = FactoryGirl.create(:project)
      @tandel = FactoryGirl.create(:custom_platinum, name: 'tandel', project: @project)
      @platinum = SponsorshipLevel.find(1)
      @gold = SponsorshipLevel.find(2)
      @silver = SponsorshipLevel.find(3)
      @bronze = SponsorshipLevel.find(4)
    end

    it { expect(SponsorshipLevel.by_project(@project)).to \
          include(@tandel, @gold, @silver, @bronze) }

    it { expect(SponsorshipLevel.by_project(@project)).to start_with(@tandel) }
    it { expect(SponsorshipLevel.by_project(@project)).to end_with(@bronze) }
  end

  describe "#default_costs" do
    before do
      @project = FactoryGirl.create(:project)
    end

    it { expect(SponsorshipLevel.default_costs('platinum', @project)).to \
          eql @project.goal.gsub(/,/, '').to_i * 0.25 }
  end
end
