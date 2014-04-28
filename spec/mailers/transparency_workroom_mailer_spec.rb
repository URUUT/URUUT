require "spec_helper"

describe TransparencyWorkroomMailer do
  describe "#transparency_workroom_update" do
    before do
      @user = FactoryGirl.create(:user)
      @manager = FactoryGirl.create(:user)
      @project = FactoryGirl.create(:project, user: @manager)
      @email = TransparencyWorkroomMailer.transparency_workroom_update(@user, @project)
    end

    it { @email.should deliver_to @user.email }
    it { @email.should have_subject "Transparency Workroom Update" }
    it { @email.should have_body_text @user.first_name }
    it { @email.should have_body_text project_transparency_workroom_index_url(@project) }
  end
end
