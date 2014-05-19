require "spec_helper"

feature "Edit profile user" do
  before(:each) do
    StripeMock.start
    @user = FactoryGirl.create(:full_user)
    @user.membership.plan = FactoryGirl.create(:plan)
    login_as(@user, scope: :user)
  end

  context "coupon" do
    scenario "when a user try change it" do
      visit edit_user_payment_method_path(@user)
      save_and_open_page
      expect( page.has_field?('coupon') ).to be_false
    end
  end
end
