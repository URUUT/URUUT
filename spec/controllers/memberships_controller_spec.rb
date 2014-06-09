require 'spec_helper'

describe MembershipsController do

  before(:each) do
    StripeMock.start
    @user = FactoryGirl.create(:full_user)
    @projects = FactoryGirl.create_list(:project, 5, user: @user)
    MembershipsController.any_instance.stub(:authenticate_user!).and_return(true)
    MembershipsController.any_instance.stub(:current_user).and_return(@user)
    login_as(@user, scope: :user)
  end

  describe "DELETE destroy" do
    it "should destroy al ongoing projects" do
      Gateway::PlansService.any_instance.stub(:cancel_plan).and_return(true)
      delete :destroy, { user_id: @user.id, id: @user.membership.id }
      projects_lives = @user.projects.collect {|x| x.live }
      expect( @user.projects.count ).to eql 5
      expect( projects_lives ).not_to include 1
    end
  end

  after(:each) do
    StripeMock.stop
  end
end
