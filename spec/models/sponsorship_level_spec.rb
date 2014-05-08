require 'spec_helper'

describe SponsorshipLevel do

	it { should respond_to(:name) }
	it { should respond_to(:cost) }
	it { should respond_to(:description) }
	it { should respond_to(:required) }
	it { should respond_to(:funding_goal) }

  #describe "#by_project" do
  #  before do
  #    @project = FactoryGirl.create(:project)
  #    @tandel = FactoryGirl.create(:custom_platinum, name: 'tandel', project: @project)
  #    @platinum = SponsorshipLevel.find(1)
  #    @gold = SponsorshipLevel.find(2)
  #    @silver = SponsorshipLevel.find(3)
  #    @bronze = SponsorshipLevel.find(4)
  #  end

  #  it { expect(SponsorshipLevel.by_project(@project)).to \
  #        include(@tandel, @gold, @silver, @bronze) }

  #  it { expect(SponsorshipLevel.by_project(@project)).to start_with(@tandel) }
  #  it { expect(SponsorshipLevel.by_project(@project)).to end_with(@bronze) }
  #end

  describe "#default_costs" do
    before do
      @project = FactoryGirl.create(:project)
    end

    it { expect(SponsorshipLevel.default_costs('platinum', @project)).to \
          eql @project.goal.gsub(/,/, '').to_i * 0.25 }
  end

  describe "#create_custom" do
    before(:each) do
      @project = FactoryGirl.create(:project)
    end

    it "should not create custom levels when the levels are default levels with persent cost" do
      default_params = SponsorshipLevel::DEFAULT_SPONSORSHIP_LEVEL_PARAM
      SponsorshipLevel.create_custom(@project, default_params, {})
      expect(SponsorshipLevel.count).to eql 4
      expect(@project.sponsorship_benefits).not_to exist
    end

    it "should create new levels if it changes some default levels name" do
      params = {  "platinum"  => {"name"=>"Heartstone", "cost"=>'1000'},
                  "gold"      => {"name"=>"Golden", "cost"=>'200'},
                  "silver"    => {"name"=>"Silver", "cost"=>SponsorshipLevel.default_costs('silver', @project).to_s},
                  "bronze"    => {"name"=>"Bronze", "cost"=>SponsorshipLevel.default_costs('bronze', @project).to_s} }
      SponsorshipLevel.create_custom(@project, params, {})
      expect(SponsorshipLevel.where(name: 'Heartstone')).to exist
      expect(SponsorshipLevel.where(name: 'Golden')).to exist
      expect(SponsorshipLevel.where(name: 'Heartstone').first.cost).to eql 1000.0
      expect(SponsorshipLevel.where(name: 'Golden').first.cost).to eql 200.0
      expect(@project.sponsorship_benefits).not_to exist
    end

    it "should create a new default level if it changes the default cost" do
      params = {  "platinum"  => {"name"=>"Platinum", "cost"=>'1000'},
                  "gold"      => {"name"=>"Gold", "cost"=>'200'},
                  "silver"    => {"name"=>"silver", "cost"=>SponsorshipLevel.default_costs('silver', @project).to_s},
                  "bronze"    => {"name"=>"bronze", "cost"=>SponsorshipLevel.default_costs('bronze', @project).to_s} }
      SponsorshipLevel.create_custom(@project, params, {})
      expect(SponsorshipLevel.where(name: 'Platinum').count).to eql 2
      expect(SponsorshipLevel.where(name: 'Gold').count).to eql 2
      expect(@project.sponsorship_benefits).not_to exist
    end

    it "should create benefit related with the default levels" do
      default_params = SponsorshipLevel::DEFAULT_SPONSORSHIP_LEVEL_PARAM
      params = {  "platinum"  =>  { "1" =>  "1",
                                    "info_1"  =>  "New benefit",
                                    "info_2"  =>  "No include"} }
      SponsorshipLevel.create_custom(@project, default_params, params)
      expect(@project.sponsorship_benefits.where(name: "New benefit")).to exist
      expect(@project.sponsorship_benefits.where(name: "No include")).not_to exist
    end
  end
end
