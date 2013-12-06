require 'spec_helper'

describe "TransparencyWorkrooms" do
  describe "GET /" do
    it "should return 200" do
      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
      visit transparency_workroom_path
      response.status.should be(200)
    end
  end
end
