require 'spec_helper'

# describe SponsorMailer do
#   describe "Sponsor Thank You Email" do
#     email = "cbartels@uruut.com"
#     let!(:user) { FactoryGirl.create(:user) }
#     let!(:project) { FactoryGirl.create(:project, user: user, id: 1) }
#     let!(:sponsor) { FactoryGirl.create(:sponsor) }
#     let!(:project_sponsor) { FactoryGirl.create(:project_sponsor, sponsor: sponsor) }
#     let!(:mail) { SponsorMailer.sponsor_thank_you(sponsor, email) }

#     context "should be sent to new sponsor" do
#       specify { mail.body.encoded.should have_content(project_sponsor.name) }
#     end
#   end
# end