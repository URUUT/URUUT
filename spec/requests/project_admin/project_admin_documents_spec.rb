require 'spec_helper'

describe "ProjectAdmin::Documents" do
  describe "GET /project_admin_documents" do
    it "works! (now write some real specs)" do
      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
      get project_admin_documents_path
      response.status.should be(200)
    end
  end
end
