require 'spec_helper'

describe Project do

  it { should respond_to(:category) }
  it { should respond_to(:description) }
  it { should respond_to(:duration) }
  it { should respond_to(:goal) }
  it { should respond_to(:address) }
  it { should respond_to(:project_title) }
  it { should respond_to(:sponsorship_permission) }

  it { should respond_to(:city) }
  it { should respond_to(:state) }
  it { should respond_to(:zip) }
  it { should respond_to(:neighborhood) }
  it { should respond_to(:title) }
  it { should respond_to(:live) }
  it { should respond_to(:short_description) }
  it { should respond_to(:perk_permission) }

  it { should respond_to(:status) }
  it { should respond_to(:organization) }
  it { should respond_to(:website) }
  it { should respond_to(:twitter_handle) }
  it { should respond_to(:facebook_page) }
  it { should respond_to(:seed_video) }

  it { should respond_to(:story) }
  it { should respond_to(:about) }
  it { should respond_to(:large_image) }
  it { should respond_to(:seed_image) }
  it { should respond_to(:cultivation_image) }
  it { should respond_to(:ready_for_approval) }
  it { should respond_to(:organization_type) }
  it { should respond_to(:cultivation_mime_type) }

  it { should respond_to(:organization_classification) }
  it { should respond_to(:cultivation_video) }
  it { should respond_to(:campaign_deadline) }
  it { should respond_to(:sponsor_permission) }
  it { should respond_to(:step) }
  it { should respond_to(:seed_mime_type) }

  describe "custom methods" do
    before(:each) do
      @project = FactoryGirl.create(:project)
    end

    it { expect(@project.funding_active?).to be_true }

    it { expect(@project.has_classification?("501(c)(4)")).to be_true }
    it { expect(@project.has_classification?("False")).to be_false }
  end

  describe "scopes" do
    describe ".ending_today" do
      before(:each) do
        @projects_end_today = FactoryGirl.create_list(:project, 20, campaign_deadline: DateTime.now.end_of_day)
        @projects_common = FactoryGirl.create_list(:project, 10)
        @project_beginning_of_day = FactoryGirl.create_list(:project, 20, campaign_deadline: DateTime.now.beginning_of_day)
      end

      it { expect(Project.ending_today.count).to eql 40 }
      it { expect(Project.ending_today).to include @projects_end_today.first }
      it { expect(Project.ending_today).to include @project_beginning_of_day.first }
    end
  end
end
