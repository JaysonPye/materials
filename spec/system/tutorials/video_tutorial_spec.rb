# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'creating and deleting a video tutorial', type: :system do
  let(:admin_user) { create(:user, :admin) }

  before do
    sign_in admin_user
  end

  it 'allows an admin user to create a new video tutorial' do
    visit new_tutorial_path(type: 'Video')
    fill_in 'Title', with: 'sample video'
    fill_in 'Video path', with: 'https://www.youtube.com/watch?v=dQw4w9WgXcQ&ab_channel=RickAstley'
    select 'Extra Resources', from: 'Category'
    click_button 'Create Video Tutorial'
    expect(page).to have_content('sample video')
  end
end