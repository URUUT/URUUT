require 'spec_helper'

describe PagesController do
  describe "GET #media" do
    it "renders the :media view" do
      get :media
    end
  end
end