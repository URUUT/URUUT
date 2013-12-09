require 'spec_helper'

feature 'Visiting the root page' do

  scenario 'Visit home page without being signed in' do
    visit root_url
    expect(page.body).to have_content('Log In')
  end

end