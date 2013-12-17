require 'spec_helper'

feature 'Transparency Woorkroom Workflow' do
  background do
    @user = FactoryGirl.create(:user)
    login_as(@user, :scope => :user)

    @project = FactoryGirl.create(:project, user: @user)
  end

  scenario 'User visits his profile' do
    visit user_path(@user)

    expect(page).to have_content("PROJECTS I'VE CREATED")
  end

end