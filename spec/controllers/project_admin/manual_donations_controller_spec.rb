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

#   describe "GET show" do
#     it "assigns the requested project_admin_document as @project_admin_document" do
#       document = ProjectAdmin::Document.create! valid_attributes
#       get :show, {:id => document.to_param}, valid_session
#       assigns(:project_admin_document).should eq(document)
#     end
#   end

#   describe "GET new" do
#     it "assigns a new project_admin_document as @project_admin_document" do
#       get :new, {}, valid_session
#       assigns(:project_admin_document).should be_a_new(ProjectAdmin::Document)
#     end
#   end

#   describe "GET edit" do
#     it "assigns the requested project_admin_document as @project_admin_document" do
#       document = ProjectAdmin::Document.create! valid_attributes
#       get :edit, {:id => document.to_param}, valid_session
#       assigns(:project_admin_document).should eq(document)
#     end
#   end

#   describe "POST create" do
#     describe "with valid params" do
#       it "creates a new ProjectAdmin::Document" do
#         expect {
#           post :create, {:project_admin_document => valid_attributes}, valid_session
#         }.to change(ProjectAdmin::Document, :count).by(1)
#       end

#       it "assigns a newly created project_admin_document as @project_admin_document" do
#         post :create, {:project_admin_document => valid_attributes}, valid_session
#         assigns(:project_admin_document).should be_a(ProjectAdmin::Document)
#         assigns(:project_admin_document).should be_persisted
#       end

#       it "redirects to the created project_admin_document" do
#         post :create, {:project_admin_document => valid_attributes}, valid_session
#         response.should redirect_to(ProjectAdmin::Document.last)
#       end
#     end

#     describe "with invalid params" do
#       it "assigns a newly created but unsaved project_admin_document as @project_admin_document" do
#         # Trigger the behavior that occurs when invalid params are submitted
#         ProjectAdmin::Document.any_instance.stub(:save).and_return(false)
#         post :create, {:project_admin_document => { "document" => "invalid value" }}, valid_session
#         assigns(:project_admin_document).should be_a_new(ProjectAdmin::Document)
#       end

#       it "re-renders the 'new' template" do
#         # Trigger the behavior that occurs when invalid params are submitted
#         ProjectAdmin::Document.any_instance.stub(:save).and_return(false)
#         post :create, {:project_admin_document => { "document" => "invalid value" }}, valid_session
#         response.should render_template("new")
#       end
#     end
#   end

#   describe "PUT update" do
#     describe "with valid params" do
#       it "updates the requested project_admin_document" do
#         document = ProjectAdmin::Document.create! valid_attributes
#         # Assuming there are no other project_admin_documents in the database, this
#         # specifies that the ProjectAdmin::Document created on the previous line
#         # receives the :update_attributes message with whatever params are
#         # submitted in the request.
#         ProjectAdmin::Document.any_instance.should_receive(:update_attributes).with({ "document" => "MyString" })
#         put :update, {:id => document.to_param, :project_admin_document => { "document" => "MyString" }}, valid_session
#       end

#       it "assigns the requested project_admin_document as @project_admin_document" do
#         document = ProjectAdmin::Document.create! valid_attributes
#         put :update, {:id => document.to_param, :project_admin_document => valid_attributes}, valid_session
#         assigns(:project_admin_document).should eq(document)
#       end

#       it "redirects to the project_admin_document" do
#         document = ProjectAdmin::Document.create! valid_attributes
#         put :update, {:id => document.to_param, :project_admin_document => valid_attributes}, valid_session
#         response.should redirect_to(document)
#       end
#     end

#     describe "with invalid params" do
#       it "assigns the project_admin_document as @project_admin_document" do
#         document = ProjectAdmin::Document.create! valid_attributes
#         # Trigger the behavior that occurs when invalid params are submitted
#         ProjectAdmin::Document.any_instance.stub(:save).and_return(false)
#         put :update, {:id => document.to_param, :project_admin_document => { "document" => "invalid value" }}, valid_session
#         assigns(:project_admin_document).should eq(document)
#       end

#       it "re-renders the 'edit' template" do
#         document = ProjectAdmin::Document.create! valid_attributes
#         # Trigger the behavior that occurs when invalid params are submitted
#         ProjectAdmin::Document.any_instance.stub(:save).and_return(false)
#         put :update, {:id => document.to_param, :project_admin_document => { "document" => "invalid value" }}, valid_session
#         response.should render_template("edit")
#       end
#     end
#   end

#   describe "DELETE destroy" do
#     it "destroys the requested project_admin_document" do
#       document = ProjectAdmin::Document.create! valid_attributes
#       expect {
#         delete :destroy, {:id => document.to_param}, valid_session
#       }.to change(ProjectAdmin::Document, :count).by(-1)
#     end

#     it "redirects to the project_admin_documents list" do
#       document = ProjectAdmin::Document.create! valid_attributes
#       delete :destroy, {:id => document.to_param}, valid_session
#       response.should redirect_to(project_admin_documents_url)
#     end
#   end

end
