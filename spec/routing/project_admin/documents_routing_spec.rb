require "spec_helper"

describe ProjectAdmin::DocumentsController do
  describe "routing" do

    it "routes to #index" do
      get("/project_admin/documents").should route_to("project_admin/documents#index")
    end

    it "routes to #new" do
      get("/project_admin/documents/new").should route_to("project_admin/documents#new")
    end

    it "routes to #show" do
      get("/project_admin/documents/1").should route_to("project_admin/documents#show", :id => "1")
    end

    it "routes to #edit" do
      get("/project_admin/documents/1/edit").should route_to("project_admin/documents#edit", :id => "1")
    end

    it "routes to #create" do
      post("/project_admin/documents").should route_to("project_admin/documents#create")
    end

    it "routes to #update" do
      put("/project_admin/documents/1").should route_to("project_admin/documents#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/project_admin/documents/1").should route_to("project_admin/documents#destroy", :id => "1")
    end

  end
end
