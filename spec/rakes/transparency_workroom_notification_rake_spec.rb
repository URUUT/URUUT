require "spec_helper"

describe "transparency_workroom_notification" do
  include_context "rake"

  before(:each) do
    @user = FactoryGirl.create(:user)
    @user_2 = FactoryGirl.create(:user)
    @manager = FactoryGirl.create(:user)
    @project = FactoryGirl.create(:project, user: @manager)
    @project.posts << Post.new
    @mails_delivers = 0
    TransparencyWorkroomMailer.any_instance.stub(:transparency_workroom_update) do
      @mails_delivers += 1
    end
  end

  its(:prerequisites) { should include("environment") }

  it "should send to project donors emails" do
    @project.donations << Donation.new({user_id: @user.id, project_id: @project.id})
    @project.donations << Donation.new({user_id: @user_2.id, project_id: @project.id})
    subject.invoke

    expect(@mails_delivers).to eql @project.donations.count
  end

  it "should not send any mail if project has not at least documents|posts|galleries" do
    @project.posts = []
    subject.invoke

    expect(@mails_delivers).to eql 0
  end

  it "should send mails to sponsors" do
    sponsor = Sponsor.new({email: @user.email})
    sponsor.save!
    @project.project_sponsors << ProjectSponsor.new({name: 'name', level_id: 1, anonymous: true, sponsor_id: sponsor.id})

    subject.invoke
    expect(@mails_delivers).to eql @project.sponsors.count
  end

  it "should send mails to sponsors and donors" do
    @project.donations << Donation.new({user_id: @user.id, project_id: @project.id})
    sponsor = Sponsor.new({email: @user.email})
    sponsor.save!
    @project.project_sponsors << ProjectSponsor.new({name: 'name', level_id: 1, anonymous: true, sponsor_id: sponsor.id})

    subject.invoke
    expect(@mails_delivers).to eql(@project.sponsors.count + @project.donations.count)
  end
end
