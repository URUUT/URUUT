require 'spec_helper'

# This spec was generated by rspec-rails when you ran the scaffold generator.
# It demonstrates how one might use RSpec to specify the controller code that
# was generated by Rails when you ran the scaffold generator.
#
# It assumes that the implementation code is generated by the rails scaffold
# generator.  If you are using any extension libraries to generate different
# controller code, this generated spec may or may not pass.
#
# It only uses APIs available in rails and/or rspec-rails.  There are a number
# of tools you can use to make these specs even more expressive, but we're
# sticking to rails and rspec-rails APIs to keep things simple and stable.
#
# Compared to earlier versions of this generator, there is very limited use of
# stubs and message expectations in this spec.  Stubs are only used when there
# is no simpler way to get a handle on the object needed for the example.
# Message expectations are only used when there is no simpler way to specify
# that an instance is receiving a specific message.

describe ProjectAdmin::DocumentsController do

  # This should return the minimal set of attributes required to create a valid
  # ProjectAdmin::Document. As you add validations to ProjectAdmin::Document, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) { { "document" => "MyString" } }

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # ProjectAdmin::DocumentsController. Be sure to keep this updated too.
  let(:valid_session) { {} }

  describe "GET index" do
    it "assigns all project_admin_documents as @project_admin_documents" do
      document = ProjectAdmin::Document.create! valid_attributes
      get :index, {}, valid_session
      assigns(:project_admin_documents).should eq([document])
    end
  end

  describe "GET show" do
    it "assigns the requested project_admin_document as @project_admin_document" do
      document = ProjectAdmin::Document.create! valid_attributes
      get :show, {:id => document.to_param}, valid_session
      assigns(:project_admin_document).should eq(document)
    end
  end

  describe "GET new" do
    it "assigns a new project_admin_document as @project_admin_document" do
      get :new, {}, valid_session
      assigns(:project_admin_document).should be_a_new(ProjectAdmin::Document)
    end
  end

  describe "GET edit" do
    it "assigns the requested project_admin_document as @project_admin_document" do
      document = ProjectAdmin::Document.create! valid_attributes
      get :edit, {:id => document.to_param}, valid_session
      assigns(:project_admin_document).should eq(document)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new ProjectAdmin::Document" do
        expect {
          post :create, {:project_admin_document => valid_attributes}, valid_session
        }.to change(ProjectAdmin::Document, :count).by(1)
      end

      it "assigns a newly created project_admin_document as @project_admin_document" do
        post :create, {:project_admin_document => valid_attributes}, valid_session
        assigns(:project_admin_document).should be_a(ProjectAdmin::Document)
        assigns(:project_admin_document).should be_persisted
      end

      it "redirects to the created project_admin_document" do
        post :create, {:project_admin_document => valid_attributes}, valid_session
        response.should redirect_to(ProjectAdmin::Document.last)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved project_admin_document as @project_admin_document" do
        # Trigger the behavior that occurs when invalid params are submitted
        ProjectAdmin::Document.any_instance.stub(:save).and_return(false)
        post :create, {:project_admin_document => { "document" => "invalid value" }}, valid_session
        assigns(:project_admin_document).should be_a_new(ProjectAdmin::Document)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        ProjectAdmin::Document.any_instance.stub(:save).and_return(false)
        post :create, {:project_admin_document => { "document" => "invalid value" }}, valid_session
        response.should render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested project_admin_document" do
        document = ProjectAdmin::Document.create! valid_attributes
        # Assuming there are no other project_admin_documents in the database, this
        # specifies that the ProjectAdmin::Document created on the previous line
        # receives the :update_attributes message with whatever params are
        # submitted in the request.
        ProjectAdmin::Document.any_instance.should_receive(:update_attributes).with({ "document" => "MyString" })
        put :update, {:id => document.to_param, :project_admin_document => { "document" => "MyString" }}, valid_session
      end

      it "assigns the requested project_admin_document as @project_admin_document" do
        document = ProjectAdmin::Document.create! valid_attributes
        put :update, {:id => document.to_param, :project_admin_document => valid_attributes}, valid_session
        assigns(:project_admin_document).should eq(document)
      end

      it "redirects to the project_admin_document" do
        document = ProjectAdmin::Document.create! valid_attributes
        put :update, {:id => document.to_param, :project_admin_document => valid_attributes}, valid_session
        response.should redirect_to(document)
      end
    end

    describe "with invalid params" do
      it "assigns the project_admin_document as @project_admin_document" do
        document = ProjectAdmin::Document.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        ProjectAdmin::Document.any_instance.stub(:save).and_return(false)
        put :update, {:id => document.to_param, :project_admin_document => { "document" => "invalid value" }}, valid_session
        assigns(:project_admin_document).should eq(document)
      end

      it "re-renders the 'edit' template" do
        document = ProjectAdmin::Document.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        ProjectAdmin::Document.any_instance.stub(:save).and_return(false)
        put :update, {:id => document.to_param, :project_admin_document => { "document" => "invalid value" }}, valid_session
        response.should render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested project_admin_document" do
      document = ProjectAdmin::Document.create! valid_attributes
      expect {
        delete :destroy, {:id => document.to_param}, valid_session
      }.to change(ProjectAdmin::Document, :count).by(-1)
    end

    it "redirects to the project_admin_documents list" do
      document = ProjectAdmin::Document.create! valid_attributes
      delete :destroy, {:id => document.to_param}, valid_session
      response.should redirect_to(project_admin_documents_url)
    end
  end

end
