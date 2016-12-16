require 'rails_helper'

feature 'Landing page' do
  it 'welcomes user' do
    visit '/'
    expect(page).to have_content 'Welcome to speedrail'
  end
end
