require 'spec_helper'

describe ProjectAdmin::ManualDonationsController do
  let(:user) { FactoryGirl.create(:user) }
  let(:project) { FactoryGirl.create(:project, user: user) }
  let(:manual_donations) { FactoryGirl.create_list(:manual_donation, 5, project: project) }
  let(:manual_donation) { FactoryGirl.build(:manual_donation) }

  before(:each) do
    ProjectAdmin::ManualDonationsController.any_instance.
      stub(:authenticate_user!).and_return(true)
    ProjectAdmin::ManualDonationsController.any_instance.
      stub(:admin_required!).and_return(true)
    login_as(@user, scope: :user)

    project.manual_donations << manual_donations
  end

  describe "before_filtes" do
    before(:each) { get :index, { project_id: project.id, format: 'js' } }
    it { expect( assigns(:project) ).to eql project }
  end

  describe "GET index" do
    before(:each) { get :index, { project_id: project.id, format: 'js' } }
    it { expect( assigns(:manual_donations) ).to match_array manual_donations }
  end

  describe "POST create" do
    before(:each) do
      @manual_donation = FactoryGirl.attributes_for(:manual_donation)
    end

    describe "with valid data" do
      before(:each) do
        post :create, { project_id: project.id, manual_donation: @manual_donation }
        project.reload
      end
      it { expect( project.manual_donations.where(email: @manual_donation[:email]) ).to exist }
    end

    describe "with invalid data" do
      before(:each) do
        post :create, { project_id: project.id, manual_donation: {}, format: :json }
        project.reload
      end

      it { expect( project.manual_donations.where(email: @manual_donation[:email]) ).not_to exist }
      it { expect(response.code).to eql "422" }
      it { expect(response.body).to eql "{\"email\":[\"can't be blank\"],\"first_name\":[\"can't be blank\"],\"last_name\":[\"can't be blank\"],\"amount\":[\"can't be blank\"]}"}
    end
  end

  describe "DELETE delete" do
    before(:each) do
      @deleted_donation = project.manual_donations.first
      delete :destroy, { project_id: project.id, id: @deleted_donation.id }
      project.reload
    end

    it { expect( project.manual_donations ).not_to include @deleted_donation }
  end
end
